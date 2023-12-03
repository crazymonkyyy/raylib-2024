import std.stdio;
import std.file;
import std.path;
import std.compiler;
import std.system;
import std.format;
import std.conv;
import std.process;
import std.string;
import iopipe.json.serialize;
import iopipe.json.parser;
import iopipe.json.dom : JSONValue;
import std.exception;
import iopipe.traits;

// tar support copied from arsd.archive:  https://github.com/adamdruppe/arsd
// Written by Adam D. Ruppe
/++
	A header of a file in the archive. This represents the
	binary format of the header block.
+/
align(512)
struct TarFileHeader {
	align(1):
	char[100] fileName_ = 0;
	char[8] fileMode_ = 0;
	char[8] ownerUid_ = 0;
	char[8] ownerGid_ = 0;
	char[12] size_ = 0; // in octal
	char[12] mtime_ = 0; // octal unix timestamp
	char[8] checksum_ = 0; // right?????
	char[1] fileType_ = 0; // hard link, soft link, etc
	char[100] linkFileName_ = 0;
	char[6] ustarMagic_ = 0; // if "ustar\0", remaining fields are set
	char[2] ustarVersion_ = 0;
	char[32] ownerName_ = 0;
	char[32] groupName_ = 0;
	char[8] deviceMajorNumber_ = 0;
	char[8] deviceMinorNumber_ = 0;
	char[155] filenamePrefix_ = 0;

	/// Returns the filename. You should cache the return value as long as TarFileHeader is in scope (it returns a slice after calling strlen)
	const(char)[] filename() {
		import core.stdc.string;
		if(filenamePrefix_[0])
			return upToZero(filenamePrefix_[]) ~ upToZero(fileName_[]);
		return upToZero(fileName_[]);
	}

	///
	ulong size() {
		import core.stdc.stdlib;
		return strtoul(size_.ptr, null, 8);
	}

	///
	TarFileType type() {
		if(fileType_[0] == 0)
			return TarFileType.normal;
		else
			return cast(TarFileType) (fileType_[0] - '0');
	}

        uint mode() {
            import std.conv : to;
            return fileMode_.upToZero.to!int(8);
        }
}

/// There's other types but this is all I care about. You can still detect the char by `((cast(char) type) + '0')`
enum TarFileType {
	normal = 0, ///
	hardLink = 1, ///
	symLink = 2, ///
	characterSpecial = 3, ///
	blockSpecial = 4, ///
	directory = 5, ///
	fifo = 6 ///
}

/++
	Low level tar file processor. You must pass it a
	TarFileHeader buffer as well as a size_t for context.
	Both must be initialized to all zeroes on first call,
	then not modified in between calls.

	Each call must populate the dataBuffer with 512 bytes.

	returns true if still work to do.
+/
bool processTar(
	TarFileHeader* header,
	long* bytesRemainingOnCurrentFile,
	ubyte[] dataBuffer,
	scope void delegate(TarFileHeader* header, bool isNewFile, bool fileFinished, ubyte[] data) handleData
)
{
    assert(dataBuffer.length == 512);
    assert(bytesRemainingOnCurrentFile !is null);
    assert(header !is null);

    if(*bytesRemainingOnCurrentFile) {
        bool isNew = *bytesRemainingOnCurrentFile == header.size();
        if(*bytesRemainingOnCurrentFile <= 512) {
            handleData(header, isNew, true, dataBuffer[0 .. cast(size_t) *bytesRemainingOnCurrentFile]);
            *bytesRemainingOnCurrentFile = 0;
        } else {
            handleData(header, isNew, false, dataBuffer[]);
            *bytesRemainingOnCurrentFile -= 512;
        }
    } else {
        *header = *(cast(TarFileHeader*) dataBuffer.ptr);
        auto s = header.size();
        *bytesRemainingOnCurrentFile = s;
        if(header.type() == TarFileType.symLink)
            handleData(header, true, true, cast(ubyte[])header.linkFileName_.upToZero);
        if(header.type() == TarFileType.directory)
            handleData(header, true, false, null);
        if(s == 0 && header.type == TarFileType.normal)
            return false;
    }

    return true;
}

T[] upToZero(T)(T[] input)
{
    foreach(i, v; input)
        if(v == 0)
            return input[0 .. i];
    return input;
}


version(X86)
	enum arch="x86";
else version(X86_64)
	enum arch="x86_64";
else version(ARM)
	enum arch="arm";
else version(AArch64)
	enum arch="arm64";
else
	static assert(false, "Unsupported architecture");

// establish the runtime
version(CRuntime_Microsoft)
	enum CRT="MSVC";
else version(CRuntime_Glibc)
	enum CRT="glibc";
else version(CppRuntime_Clang)
	enum CRT="llvm";
else
	static assert(false, "Unsupported runtime");

enum osStr = os.to!string;

enum baseDir = buildPath("install", "lib", osStr, arch, CRT);

auto writeTo(C, S)(C chain, S sink)
{
    import iopipe.bufpipe;
    import iopipe.valve;
    return chain.push!(c => c.outputPipe(sink));
}

void extractArchive(char[] path)
{
    import std.io : File, mode;
    import iopipe.bufpipe;
    import iopipe.refc;
    import iopipe.zip;

    auto archivePath = buildPath(path, "install", "lib.tgz");
    auto expectedPrefix = "lib/" ~ osStr ~ "/";
    enforce(exists(archivePath), "No lib archive found at " ~ archivePath ~ "!");

    // the input file
    auto inputFile = File(archivePath, mode!"rb").refCounted.bufd.unzip;

    bool doOutput;

    // open a file using iopipe
    auto openOutputFile(string fname)
    {
        return bufd.writeTo(File(fname, mode!"wb").refCounted);
    }
    typeof(openOutputFile("")) currentFile;
    string currentSymlinkText;

    void handleTar(TarFileHeader *header, bool isNewFile, bool fileFinished, ubyte[] data)
    {
        auto ft = header.type;
        if(isNewFile)
        {
            // check that the name matches
            auto fn = header.filename;
            if(!fn.startsWith(expectedPrefix))
                return;

            version(Posix)
            {
                // handle symlinks on posix
                if(ft == TarFileType.symLink)
                {
                    doOutput = true;
                    currentSymlinkText = "";
                }
            }

            if(ft == TarFileType.normal)
            {
                doOutput = true;
                auto newFilePath = buildPath(path, "install", fn);
                mkdirRecurse(dirName(newFilePath));
                currentFile = openOutputFile(newFilePath);
            }
        }

        if(doOutput)
        {
            if(ft == TarFileType.symLink)
                currentSymlinkText ~= cast(char[])data;
            else
            {
                currentFile.ensureElems(data.length);
                assert(currentFile.window.length >= data.length);
                currentFile.window[0 .. data.length] = data[];
                currentFile.release(data.length);
            }
        }

        if(fileFinished)
        {
            if(doOutput)
            {
                auto fn = header.filename;
                auto fp = buildPath(path, "install", fn);
                version(Posix)
                {
                    if(ft == TarFileType.symLink)
                    {
                        mkdirRecurse(dirName(fp));
                        symlink(currentSymlinkText, fp);
                    }
                }
                if(ft == TarFileType.normal)
                {
                    // close the file
                    destroy(currentFile);
                    // Effect the correct file permissions
                    version(Posix)
                    {
                        setAttributes(fp, header.mode);
                    }
                }
                doOutput = false;
            }
        }
    }

    // for tar
    TarFileHeader tfh;
    long size;

    while(inputFile.extend(0) > 0)
    {
        while(inputFile.window.length >= 512)
        {
            // big enough to process another tar chunk
            processTar(&tfh, &size, inputFile.window[0 .. 512], &handleTar);
            inputFile.release(512);
        }
    }
}

int main()
{
    writeln("raylib-d library installation");
    // look at the dub.selections.json file
    auto dubConfig = execute(["dub", "describe"], null, Config.stderrPassThrough);
    string raylibdPath;
    if(dubConfig.status != 0)
    {
        stderr.writeln("Error executing dub describe");
        return dubConfig.status;
    }
    char[] getRaylibPath(char[] jsonStr)
    {
        auto tokens = jsonTokenizer(jsonStr);
        enforce(tokens.parseTo("packages"), "Could not find packages in dub json output!");
        auto nt = tokens.next.token;
        enforce(nt == JSONToken.ArrayStart, "Expected array start in packages");
        while(nt != JSONToken.ArrayEnd)
        {
            tokens.releaseParsed();
            tokens.startCache;
            enforce(tokens.parseTo("name"), "Could not find package name in json file");
            auto n = tokens.next;
            jsonExpect(n, JSONToken.String, "Expected string for package name");
            if(n.data(tokens.chain) == "raylib-d")
            {
                tokens.rewind;
                tokens.parseTo("path");
                auto p = tokens.next;
                jsonExpect(p, JSONToken.String, "Expected string for path");
                return p.data(tokens.chain);
            }
            tokens.rewind;
            tokens.endCache;
            nt = tokens.skipItem;
            // skip whatever the next token is, it's either a comma, or the array end.
            cast(void)tokens.next;
        }
        throw new Exception("Could not find raylib-d dependency for current project!");
    }
    try {
        auto path = getRaylibPath(dubConfig.output.dup);
        // check to see if the `lib` directory exists, and if not, see if we can extract it from a tarball
        writeln("Detected raylib dependency path as ", path);
        auto libpath = buildPath(path, baseDir);
        writeln("Copying library files from ", libpath);
        if(!exists(libpath))
        {
            // extract the data, but only for the detected OS
            writeln("Library path does not exist, trying archive");
            extractArchive(path);
        }
        foreach(ent; dirEntries(libpath, SpanMode.shallow))
        {
            auto newLoc = buildPath(".", ent.name.baseName(".lnk"));
            if(exists(newLoc))
            {
                writeln("Skipping existing file ", newLoc);
                continue;
            }
            version(Posix)
            {
                void makeLink(string origln)
                {
                    writefln("Creating symlink %s -> %s", newLoc, origln);
                    symlink(origln, newLoc);
                }
                if(ent.isSymlink)
                {
                    // recreate the symlink
                    makeLink(readLink(ent.name));
                    continue;
                }
                else if(ent.name.endsWith(".lnk"))
                {
                    // dub workaround. This is really a symlink but wasn't
                    // properly downloaded by dub.
                    makeLink(readText(ent.name));
                    continue;
                }
            }
            writefln("Installing library file %s", newLoc);
            copy(ent.name, newLoc, PreserveAttributes.yes);
        }
    } catch(Exception ex) {
        stderr.writeln("Error: ", ex.msg);
        return 1;
    }

    // display what to put in the json or sdl file
    if(exists("dub.json"))
    {
        import std.io : File, mode;
        import iopipe.bufpipe;
        import iopipe.refc;
        import iopipe.textpipe;
        import std.algorithm : canFind;
        // json, we can handle. Read the file and check for the correct flags
        static struct DubFile {
            @optional:
            string[] libs;
            @alternateName("lflags-posix") string[] lflagsPosix;
            @alternateName("lflags-osx") string[] lflagsOsx;
            @alternateName("lflags-linux") string[] lflagsLinux;
            @extras JSONValue!string _extras;
        }
        auto dubfile = File("dub.json", mode!"rb").refCounted.bufd.assumeText.deserialize!DubFile;
        // check to see that all the proper things are present
        bool hasLib = dubfile.libs.canFind("raylib");
        bool hasPosixFlags = dubfile.lflagsPosix.canFind("-L.");
        bool hasOsxFlags = dubfile.lflagsOsx.canFind(["-rpath", "@executable_path/"]);
        bool hasLinuxFlags = dubfile.lflagsLinux.canFind("-rpath=$$ORIGIN");
        if(!hasLib || !hasPosixFlags || !hasOsxFlags || !hasLinuxFlags)
        {
            writeln(
`Proper dub linker directives missing, the following directives in dub.json will link the installed raylib library:
    "libs": [ "raylib" ],
    "lflags-posix" : ["-L."],
    "lflags-osx" : ["-rpath", "@executable_path/"],
    "lflags-linux" : ["-rpath=$$ORIGIN"]`);

            // ask the user if they want to update the dub.json file with the
            // correct directives.
            write("Automatically add these directives to your dub.json file? [Y/n] ");
            stdout.flush();
            auto result = readln().strip;
            if(result == "Y" || result == "y" || result == "")
            {
                // add the correct directives
                if(!hasLib)
                    dubfile.libs ~= "raylib";
                if(!hasPosixFlags)
                    dubfile.lflagsPosix ~= "-L.";
                if(!hasOsxFlags)
                    dubfile.lflagsOsx ~= ["-rpath", "@executable_path/"];
                if(!hasLinuxFlags)
                    dubfile.lflagsLinux ~= "-rpath=$$ORIGIN";
                // rewrite the file
                std.file.write("dub.json", serialize(dubfile));
                writeln("dub.json file updated!");
            }
        }
    }
    else if(exists("dub.sdl"))
    {
        writeln(
`If not already present, the following directives in dub.sdl will link the installed raylib library:
    libs "raylib"
    lflags "-rpath" "@executable_path/" platform="osx"
    lflags "-L." platform="posix"
    lflags "-rpath=$$ORIGIN" platform="linux"`);
    }
    return 0;
}
