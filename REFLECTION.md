## what did I do?
I performed a compile build for windows OS with amd64 Architecture.
When I compared the binary contents between the ./main and ./main-exe using opencode, 
I see that thefile formats changed. They are completely different executable formats (ELF vs PE). 
This is due to the fact we learnt in class that the static languages need to be directly compiled 
into target OS and Architecture combibation because each architecture require their own instruction 
lengths and format as well as each OS interprets the given binaries in different ways before they 
pass it to CPU hence this difference was expected.

In addition I built the stripped artifact (main-stripped) using the -ldflags='-s -w' flags
These flags removed the unneded symbol table and the debug information, which eventually
created a lighter binary. I learnt that these extra information are normally embedded in order to
help with the debug process. -s removed the symbol tables and -w removed debug sections, and now we cannot know with human eyes
the name of the functions during debug stage. the ./main build is around 7.1mb whie
stripped build is around 4.9 mb, which is around 30% smaller.

## what was most surprising?
The most interesting thing for me was how the LLM was able to understand the generated build artifact
and explain the differences, as when I try to cat over the built artifacts,
I get weird characters. In addition, I realised that the size of the builds
are pretty similar (only ~656 bytes difference). I am not sure whether this would be the case if we had a bigger
go application. For the second task, to me the most surprising part is how much smaller the stripped build is and how much debug information 
is taking up the space.

## What's still unclear?
The concept of linker is only understood in high level. I am not feeling very comfortable to be a DevOps engineer
who uses best practices for dependency management during builds and deployment.

