%Load file and sample frequncy, and get rid of second channel
[x,freq]=audioread('/Users/alfonsodamelio/Desktop/DATA SCIENCE/2°SEMESTRE/Data monitoring (MATLAB)/HW1/Chord.wav');
x = x(:,1);


%Compute FFT with sample frequency
FFT=abs(fft(x,freq));  % Fast Fourier Transform

%Plot FFT if necesssary
%figure(1)
stem(FFT)

%Sort fft per value
[fft_value,fft_freq] = sort(FFT(freq/2+1:freq), 'descend');

%Total energy
Ene = sum(FFT(freq/2+1:freq).^2);

%a for equal tempered scale formula
a=2^(1/12);

%total energy initialization
tot_nrg=fft_value(1)^2;

%instead of using first frequency as it is, transform to the real frequency
%of the note it corresponds (e.g. 92-->92.5)
new=freq/2+1-fft_freq(1);
n_note=round(log(new/440)/log(a));
new=440*a^(n_note);

%Principal notes initialization
notes = new;
nrg_notes = fft_value(1)^2;
treshold=0.8;

for i = 2:freq/2
    new = freq/2+1-fft_freq(i);
    n_note=round(log(new/440)/log(a));
    new=440*a^(n_note);
    
    tot_nrg=tot_nrg+fft_value(i)^2;
    add = true;
    for j = 1:length(notes)
        if new>=notes(j)
            armonica = round(new/notes(j));

            %((notes(j)*a)-notes(j))/2 AND ((notes(j)/a)-notes(j))/2 are the
            %semi-distance from the next and previous note
            if armonica >= new/(notes(j)+((notes(j)*a)-notes(j))/2) && armonica <= new/(notes(j)+((notes(j)/a)-notes(j))/2)
                add = false;
                nrg_notes(j)=nrg_notes(j)+fft_value(i)^2;
                break
            end
        end
    end
    if add == true
        n_note=round(log(new/440)/log(a));
        new=440*a^(n_note);
        notes=[notes,new];
        nrg_notes=[nrg_notes,fft_value(i)^2];
    end
    if tot_nrg>Ene*treshold
        break
    end
end
 

%Da C0 a B8 ---> n in -57:50
notes_rows=sort(round(log(notes/440)/log(a))+57); %(with 57 first row is 0)

%to recognize notes---> from 0 to 11: C0--->B0, 12 to 23: C1--->B1, ...
letters={'C' 'C#/Db' 'D' 'D#/Eb' 'E' 'F' 'F#/Gb' 'G' 'G#/Ab' 'A' 'A#/Bb' 'B'};
notes_numbers=fix(notes_rows/12);
notes_types=rem(notes_rows,12)+1;
notes_letters=letters(notes_types);

%the recognized notes are:
%%%%%BISOGNA FINIRE QUESTO: CONCATENARE LETTERE E NUMERO DELLE NOTE E
%%%%%STAMPARE
%vertcat(notes_letters,' ',num2cell(num2str(notes_numbers)))

%{
chords=['Major' 1 3 5,
'Minor' 1 b3 5,
'7th' 1 3 5 b7,
'Major 7th' 1 3 5 7,
'Minor 7th' 1 b3 5 b7,
'6th' 1 3 5 6,
'Minor 6th' 1 b3 5 6,
'Diminished' 1 b3 b5,
'Diminished 7th' 1 b3 b5 bb7,
'Half diminished 7th' 1 b3 b5 b7,
'Augmented' 1 3 #5,
'7th #5' 1 3 #5 b7,
'9th' 1 3 5 b7 9,
'7th #9' 1 3 5 b7 #9,
'Major 9th' 1 3 5 7 9,
'Added 9th' 1 3 5 9,
'Minor 9th' 1 b3 5 b7 9,
'Minor add 9th' 1 b3 5 9,
'11th' 1 3 5 b7 9 11,
'11th (3 omitted)' 1 5 b7 9 11
'Minor 11th' 1 b3 5 b7 9 11,
'7th #11' 1 3 5 b7 #11,
'Major 7th #11' 1 3 5 7 9 #11,
'13th' 1 3 5 b7 9 11 13,
'13th (11 omitted)' 1 3 5 b7 9 13,
'Major 13th' 1 3 5 7 9 11 13,
'Major 13th (11 omitted)' 1 3 5 7 9 13,
'Minor 13th' 1 b3 5 b7 9 11 13,
'Suspended 4th (sus, sus4)' 1 4 5,
'Suspended 2nd (sus2)' 1 2 5,
'5th (power chord)' 1 5]
%}

chords_names={'Major'
'Minor'
'7th'
'Major 7th'
'Minor 7th'
'6th'
'Minor 6th'
'Diminished'
'Diminished 7th'
'Half diminished 7th'
'Augmented'
'7th #5'
'9th'
'7th #9'
'Major 9th'
'Added 9th'
'Minor 9th'
'Minor add 9th'
'11th'
'11th (3 omitted)'
'Minor 11th'
'7th #11'
'Major 7th #11'
'13th'
'13th (11 omitted)'
'Major 13th'
'Major 13th (11 omitted)'
'Minor 13th'
'Suspended 4th (sus, sus4)'
'Suspended 2nd (sus2)'
'5th (power chord)'};

chords=[1 3 5 0 0 0 0
1 2.5 5 0 0 0 0
1 3 5 6.5 0 0 0
1 3 5 7 0 0 0
1 2.5 5 6.5 0 0 0
1 3 5 6 0 0 0
1 2.5 5 6 0 0 0
1 2.5 4.5 0 0 0 0
1 2.5 4.5 6 0 0 0
1 2.5 4.5 6.5 0 0 0
1 3 5.5 0 0 0 0
1 3 5.5 6.5 0 0 0
1 3 5 6.5 9 0 0
1 3 5 6.5 9.5 0 0
1 3 5 7 9 0 0
1 3 5 9 0 0 0
1 2.5 5 6.5 9 0 0
1 2.5 5 9 0 0 0
1 3 5 6.5 9 11 0
1 5 6.5 9 11 0 0
1 2.5 5 6.5 9 11 0
1 3 5 6.5 11.5 0 0
1 3 5 7 9 11.5 0
1 3 5 6.5 9 11 13
1 3 5 6.5 9 13 0
1 3 5 7 9 11 13
1 3 5 7 9 13 0
1 2.5 5 6.5 9 11 13
1 4 5 0 0 0 0
1 2 5 0 0 0 0
1 5 0 0 0 0 0];

      %1  2  3  4  5 6  7  8  9  10  11  12 13  14 15  16 17 18  19  20  21  22  23  24
trnsf=[1 1.5 2 2.5 3 4 4.5 5 5.5  6  6.5  7  8 8.5  9 9.5 10 11 11.5 12 12.5 13 13.5 14];
%trnsf works like a transformation function to map notes distance to the structure of chords

try
    for k = 3:length(notes_rows)
        
        if nrg_notes(k)>=0.01*tot_nrg
            chord_structure=trnsf(notes_rows(1:k)-notes_rows(1)+1);


            for i=1:length(chords)
                c=chords(i,:);
                real_length=0;
                for j=1:length(c)
                    if c(j)==0
                        real_length=j-1;
                        break
                    end
                end
                if isequal(chords(i,1:real_length),chord_structure)

                fprintf('The chord is: %s %s, composed by these %d notes: %s, %s, %s, %s, %s, %s',chords_names{i},notes_letters{1},length(notes_numbers),notes_letters{:})
                    break
                end
            end
        end

    end
 catch exception
            fprintf('you should increase or decrease the treshold');
        
end
