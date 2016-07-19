import std.stdio, std.array, std.algorithm, std.string, std.regex, std.utf, std.encoding;

string convFromASCII(char[] lin)
{
	string res;
	transcode(cast(Latin1String) lin, res);
	return res;
}

char[] convToASCII(string lin)
{
	Latin1String res;
	transcode(lin,res);
	return cast(char[]) res;
}

int main(string[] args)
{
    if (args.length < 2 || args.length > 3)
	{
		writeln("command line: xltologix original.csv [processado.csv]");
		return 1;
	}
	auto entrada = File(args[1],"r");
	string nome_saida;
	if (args.length == 3)
	{
		nome_saida = args[2];
	}
	else
	{
		nome_saida = replaceFirst(args[1],regex(`(.*\\|/)(.+)$`),"$1logix_$2");
	}
	auto saida = File(nome_saida,"w+");
	auto rex = ctRegex!(`(.*)(?:;|\t)(.*)(?:;|\t)(.{0,20}(?!\w)) ?(.{0,20}(?!\w)) ?(.{0,20}(?!\w)) ?(.{0,20}(?!\w)) ?(.{0,20}(?!\w)).*`);
	entrada.byLine()
		.map!convFromASCII()
		.map!(l => strip(replaceFirst(l,rex,"$1,0,$2,$3,$4,$5,$6,$7")))
		.map!convToASCII()
		.each!(l => saida.writeln(l));
	return 0;
}
