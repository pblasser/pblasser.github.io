//This is a manual to assemble an analog synth,
//called Tocante, and a musical simulator of its
//Capacitors that tune it! Thus the relationship
//of comment to code is like soldering to music.

//general procedure is to insert components in order,
//solder one leg of each from top, then flip the board.
//this way you can nip the leads flush to the fancy board,
//and finish solder nice flat rounded domes there.

//use lead free solder please, so kids can touch it.
//the last step is seal the masked nodes with nail polish.
//check my video on making a case out of desert juniper!
//following any part numbers (PN#) are from mouser.
//but they can also arrive from china chains of ebay...

////////////////////////////////////////////
////////////////////////RESISTORS
////////////////////////////////////////////
//Resistors, as always, are the first thing first.
//Let's do "as always" as much as possible.
//47,10k,22k,100k,220k,470k,1m are all values,
//"SP": 4.7k on BISTAB, 6.8k on PHASHI, 10k on THYRIS.
//Use 1/8W, for example PN# 299-10k.
//diodes are 1N4148, include them with resistors,
//they are polarized: line up band with symbol, boom!

/////////////////////////////////////////////
////////////////////////TRANSISTORS
/////////////////////////////////////////////
//Do all transistors and leave caps for last
//The bulk of transistors is + and -, or PNP and NPN.
//I use BC557B and BC546B but you can substitute.
//The legend is for BC style, but you can use 2N style too,
//Just rotate those transistors (2N2907) 180 degrees.

//the other transistors are mosfets, + and -
//enclosed in a box, and a 9 volt regulator,
//9 is L78L09. [+] are VP2106, [-] 2N7000.
//the chip is NJM2073D, boom!

//Let's include the red LEDs, PN# WP424SRDT
//Fold their leads over so they can point out the board,
//Make sure shortest lead goes where teeth point in symbol.
//Speaking of teethed symbols, do the mosfet protection,
//Zener or TVS P6KE18A. THen you can do the inductor,
//in the spiral symbol, you want 10mH, 100ma, like
//bournes PN# RLB9012-103KL. The speaker is AS06608MRR

//Stranded wire from crown symbol to speaker (not polarized).
//Output jack is pod symbol, base is ground.
//Battery is obelisk symbol, base is ground.
//Battery is NiMH series sixpack of AAA, about 800mAh.
//Ebay for 7.2v NiMH AAA. You could also try 9v battery.
//Solar panel is 6V 100mA 0.6W from China, 60x90mm.

//The power jack, PN# 163-4302-E, has three wires.
//Its connect symbol thus has three pads, one for 12v positive,
//that is at the top of its pointy head. The
//other two pads are battery switch and ground.
//they are left and right respectively, below positive.
//With no power plug, battery should connect to ground.
//With a power plug, battery should disconnect.
//You can check this with an unpowered plug.

/////////////////////////////////////////////
////////////////////////CAPACITORS
/////////////////////////////////////////////
//There are a smattering of 1u, 10n, and 1n caps.
//These can be TDK MLCC, or film capacitors.

//Now we've gotten to the place where you pick a tuning.
//The symbol with a star in it is a hairy capacitor.
//There is one simplest way: to put a single capacitor here,
//of any variety and capacity. put it onto the outside holes.
//to make a parallel connection, put two capacitors in,
//one on top of the other, both connecting to the outside holes.
//the two "islands" in the middle are for serial connections;
//capacitor jumps to island and another capacitor jumps out.
//now. about notation. the simple single capacitor, code "472"
//parallel two of those and it's "472:472" serial is "472-472"
//you are also capable of parallel-serial and serial-parallel:
//for example, code 102-152:222-332 and 472:682-822:103
//you load up the block with four caps. Here's how to decode:
//A-B:C-D is A jumps to the island and B jumps out,
//and, C jumps to the other island and D jumps out,
//they are separate serial paths.
//A:B-C:D is A ontop of B, connected by a massive island,
//to C ontop of D, you glob the two islands together!
//the thyris has exactly one hairy capacitor per oscillator;
//bistab is two and phashi is three! observe them clumped;
//respect clumping with the same capacitors.
//the fun way is to plug and play different tunings.
//since you saved caps for last, you can carefully energize
//the circuit without hairy caps, and try one oscillator at a time.

//what brand did you buy? TDK leaded MLCCs on mouser,
//but there's myriad random jellybeans on ebay too!
//tolerance is how much they deviate. think about precision.
//poke around with different values and pick something you like,
//or you can use supercollider to pick them for you.
//now the code is active, select all and press shift-enter:

(
//Here's the synths, thyris phashi and bistab,
//saw, sine and square, and a GUI for triggering the scales.
SynthDef(\thyris, {|freq,gate=1,dur|
	Out.ar(0,Saw.ar(freq,EnvGen.kr(Env.linen(dur/2,0,dur/2), gate, doneAction: 2)));
}).add;
SynthDef(\phashi, {|freq,gate=1,dur|
	Out.ar(0,SinOsc.ar(freq,0,EnvGen.kr(Env.linen(dur/2,0,dur/2), gate, doneAction: 2)));
}).add;
SynthDef(\bistab, {|freq,gate=1,dur|
	Out.ar(0,Pulse.ar(freq/2,0.5,  EnvGen.kr(Env.linen(dur/2,0,dur/2), gate, doneAction: 2)));
}).add;
if(w!=nil,{w.close});
v=3.collect({VLayout()}); s=TextView(); w=Window("tocatuner").layout_(HLayout(v[0],v[1],v[2],s));
t={|txt|s.string=s.string++txt++"\n";};
//v[0].add(StaticText().string_("Choose Oscillator"));x=Button().states_([["thyris"],["phashi"],["bistab"]]); v[0].add(x);v[0].add(StaticText());
x=["thyris","phashi","bistab"];
u={|txt,pb| x.do({|e,i|
	v[i].add(Button().states_([[e++txt]]).action_({s.string_("");Pbindf(pb,\instrument,e).play(AppClock)}))});};
w.front;

/////////////////////////////////////////////
////////////////////////VIRTUAL CAPACITORS
/////////////////////////////////////////////
//This program demonstrates some tactics for tuning with capacitors
//First we create an array of the available capacitors, as pairs of
//picofarad values and the capacitor code as a string.
~e3 = [[100,"101"],[220,"221"],[470,"471"]];
~e6 = ~e3++[[150,"151"],[330,"331"],[680,"681"]];
~e12 = [[120,"121"],[180,"181"],[270,"271"],[390,"391"],[560,"561"],[820,"821"]];
~injector={|c,d|c.inject([],{|a,b| a++[b]++[[10**d*b[0],(b[1].asInteger+d).asString]]})};
~tocagreen =~injector.(~injector.(~e6,1),2);
~tocared = ~injector.(~injector.(~e12,1),2);
~tocabase =~tocagreen.select({|i|(i[0]<=47000)&&(i[0]>=100)});
~parclumper = { |a,b|  [a[0]+b[0],"("++a[1]++":"++b[1]++")"] };
~serclumper = { |a,b| [(1.0*a[0]*b[0])/(a[0]+b[0]),"("++a[1]++"-"++b[1]++")"] };
~tocanter = {|a,f|  a.collect({|i,ii| f.value(i,i)})};
~clumper = {|a,f|  a.collect({|i,ii| (ii+1).collect({|j|[i,a[j]]})}).flatten.collect({|i| f.value(i[0],i[1])})};
~clomper =  {|a,f|  a.collect({|i,ii| a.collect({|j,jj|[i,j]})}).flatten.collect({|i| f.value(i[0],i[1])})};
~sp = ~clumper.value(~tocabase,~serclumper)++~clumper.value(~tocabase,~parclumper);
~spp = ~clomper.value(~clumper.value(~tocabase,~parclumper)++~tocabase,~serclumper);
~pss = ~clomper.value(~clumper.value(~tocabase,~serclumper)++~tocabase,~parclumper);
~parser = ~sp++~spp++~pss++~tocabase;
~parser = ~parser.sort({|a,b| a[0]<b[0]});//.do({|i|i.postln});
~parser = ~parser.select({|i|(i[0]>100)});

/////////////////////////////////////////////
////////////////////////MATERIALS SCALE
/////////////////////////////////////////////
//The original tocante scale is materials-based, using all values equally.
//To get octaves, the values are in simple parallel and serial combinations.
~tocanter = {|t| t.inject([],{|a,b| a++[~serclumper.(b,b)]++[b]++[~parclumper.(b,b)]})};
~tocasort = {|t,min,max| t.sort({|a,b| a[0]<b[0]}).select({|i|(i[0]>=min)&&(i[0]<=max)})};
//kapton is the magic number to convert from pF to Hz. I did it by ear!
~kapton=3000000;
~harp = {|s,f|
	var pf = p{t.(s);f.do({|e,i|
		t.(e[0].asString++"pF "++e[1]);
		if ((i%6)==5, {t.("")});
		(~kapton/e[0]).yield;})};
	u.(s,Pbind(\freq, pf,\dur, 0.15));
}; ~harp_reverse = {|s,f|~harp.(s,f.reverse);};
~harp.(" green",~tocasort.(~tocanter.(~tocagreen),940,16500));
~harp.(" red",~tocasort.(~tocanter.(~tocared),1120,19500));
~harp.(" combo",~tocasort.(~tocanter.(~tocagreen++~tocared),940,16500));
~tocastutter = {|t| t.inject([],{|a,b| a++([~serclumper.(b,b)]++[b]++[~parclumper.(b,b)]).wrapExtend(6)})};
//for my prototypes i just used caps i had around the shop,
//and arranged them in octaves,
//i wanted to experiment with a keyboard organized in a
//more lacelike, interlocking, non-linear way
~harp.(" e3proto",~tocastutter.(~tocasort.(~injector.(~injector.(~e3,1),2),1000,10000)));
~harp.(" e6proto",~tocanter.(~tocasort.(~injector.(~injector.(~e6,1),2),1000,15000)));
~harp.(" e12prot",~tocanter.(~tocasort.(~injector.(~e6++~e12,1),1000,3900)));
//~harp_reverse.(" sweet",~tocastutter.(~tocasort.(~injector.(~injector.(~e3,1),2),1000,10000)));

/////////////////////////////////////////////
////////////////////////VARIANCE SCALE
/////////////////////////////////////////////
//Putting all the same capacitors in and listening to the differences in value.
//Has to do with tolerance: J code capacitors may vary by 5%
//sounding variations
~placer={|c,d|c.collect({|b|[10**d*b[0],(b[1].asInteger+d).asString]})};
~fourvar = ~placer.(~e3,1)++[~placer.(~e3,2)[0]];
~harp_variance={|s,f,vv|
	var pf = p{t.(s);f.do({|e,i|
		6.collect({
			var variance=(1+vv.rand-vv.half);
			t.((100*variance).asStringPrec(4)++"% "++e[1]);
			(~kapton/(e[0]*variance))}).yield;
		t.("");
	})};
    vv=0.01*(vv.asFloat);
	u.(s,Pbind(\freq, pf,\dur, 1));
};
~harp_variance.(" 5%",~fourvar,5);

/////////////////////////////////////////////
////////////////////////MUSICAL SCALE
/////////////////////////////////////////////
//this is the hard one: we will emulate a piano with capacitors!
//There's gonna be a bunch of capacitors and globs on the board.
~harp_simul = {|s,f|
	var ts =f.collect({|i|~parser.detect({|ii|(~kapton/i<(ii[0]+15))&&(~kapton/i>(ii[0]-15))})});
	var pf = p{t.(s);f.do({|e,i|
			t.(((~kapton/e).asFloat().asStringPrec(7)++"<-->"++
			ts[i][0].asFloat().asStringPrec(7)++"pF "++ts[i][1]));
			[e,~kapton/ts[i][0]].yield;})};
	u.(s,Pbind(\freq, pf,\dur, 0.5));
};

~dmol = [50,52,53,55,57,59,60];
~dmol = ~dmol++(~dmol+12);
~dmol = ~dmol++(~dmol+24);
~dmol = ~dmol.midicps;
~dmol.postln;
~wosta = [1,11/10,27/22,3/2,44/27,20/11]*300;
~wosta = ~wosta++(~wosta*2);
~wosta = ~wosta++(~wosta*4);
~harp_simul.(" dmol",~dmol);
//~harp_simul.("wosta of zalzal",~wosta);

)
