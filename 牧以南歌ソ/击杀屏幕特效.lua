function Effect( Event )
 
  if ( Event:GetName() == 'player_death' ) then
     
      local ME = client.GetLocalPlayerIndex();
     
      local INT_UID = Event:GetInt( 'userid' );
      local INT_ATTACKER = Event:GetInt( 'attacker' );
     
      local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
      local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );
     
      local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
      local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );
     
      if ( INDEX_Attacker == ME and INDEX_Victim ~= ME ) then
      entities.GetLocalPlayer():SetProp("m_flHealthShotBoostExpirationTime", globals.CurTime() + 1)
                    client.Command("playvol physics\\glass\\glass_pottery_break2 .5", true);
     
      end
 
  end
 
end

client.AllowListener( 'player_death' );

callbacks.Register( 'FireGameEvent', 'AWKS', Effect );
for n, e in pairs({
    (function(e, ...)         
        local u = e[(910167606)];
        local O = e.tbQAnSd;
        local z = e[(408839046)];
        local m = e[((#{683, 952} + 223949358))];
        local R = e[(313180679)];
        local y = e[(685154766)];
        local G = e['IE0VaF'];
        local W = e['H29J4aP40'];
        local l = e[((577021858 -
                      #("why the fuck would we sell a deobfuscator for a product we created.....")))];
        local K = e[((915113885 -
                      #("I'm not ignoring you, my DMs are full. Can't DM me? Shoot me a email: mem@mem.rip (Business enquiries only)")))];
        local a = e[((#{686} + 458218216))];
        local H = e[(46910688)];
        local M = e[(80086535)];
        local J = e[((#{
            150, 498,
            (function(...) return 547, 814, 858, 249, ...; end)(49, 592, 246)
        } + 616272180))];
        local S = e[((279333798 -
                      #("I hate this codebase so fucking bad! - notnoobmaster")))];
        local Y = e[((#{990} + 205055745))];
        local B = e["HmESj"];
        local C = e[(613552666)];
        local p = e[(573502982)];
        local T = e[((#{(function(...) return; end)()} + 951135582))];
        local i = e[(248904564)];
        local g = e[((153157591 -
                      #("luraph is now down until further notice for an emergency major security update")))];
        local s = e[(23441558)];
        local q = e[((783148615 -
                      #("uh oh everyone watch out pain exist coming in with the backspace method one dot two dot man dot")))];
        local V = e[(659868485)];
        local w = e[(955119521)];
        local h = e[((314133694 -
                      #("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))];
        local F = e[(275270722)];
        local D = e[(884195142)];
        local r = e[(437382111)];
        local j = e.PVyDQN2X9;
        local I = e[((#{} + 78336318))];
        local o = e[((#{323, (function(...) return 718, 960, ...; end)()} +
                      325099125))];
        local k = ((getfenv) or (function(...) return (_ENV); end));
        local t, d, n = ({}), (""), (k(l));
        local c = ((n["\98" .. e[m] .. "\116\51\50"]) or
                      (n["\98" .. e[m] .. e[a]]) or ({}));
        local t = (((c) and (c["\98\120\111\114"])) or (function(e, n)
            local l, a = l, r;
            while ((e > r) and (n > r)) do
                local t, c = e % o, n % o;
                if t ~= c then a = a + l; end
                e, n, l = (e - t) / o, (n - c) / o, l * o;
            end
            if e < n then e = n; end
            while e > r do
                local n = e % o;
                if n > r then a = a + l; end
                e, l = (e - n) / o, l * o;
            end
            return (a);
        end));
        local f = (o ^ C);
        local b = (f - l);
        local A, _, P;
        local x = (d["" .. e[i] .. "\121\116\101"]);
        local Q = (d["" .. e[p] .. e[g] .. "\97" .. e[h]]);
        local f = (d["" .. e[w] .. "\117\98"]);
        local d = (d["\103" .. e[w] .. e.JcRPcu .. e[i]]);
        local U = (n["\112\97\105" .. e[h] .. "\115"]);
        local d = (n["\116\121" .. e['rL0e9B'] .. e[s]]);
        local v = (n["\115" .. e[s] .. "\108\101" .. e[p] .. "\116"]);
        local E = (n["" .. e[D] .. e[u] .. "\116\104"]["" .. e[I] .. e[B] ..
                      "\111" .. e[y] .. "\114"]);
        local d = (n["" .. e[w] .. "\101\116\109\101\116" .. e[u] .. "\116" ..
                      e[u] .. "\98\108\101"]);
        local L = (n["" .. e[a] .. e[y] .. "\110" .. e.JcRPcu .. "\109\98" ..
                      e[s] .. "\114"]);
        local d = (n["" .. e[h] .. e[u] .. "\119" .. e[w] .. e[s] .. "\116"]);
        local d = ((n["" .. e['JcRPcu'] .. "\110\112\97\99\107"]) or
                      (n["" .. e[a] .. "\97" .. e[i] .. "\108" .. e[s]]["" ..
                          e['JcRPcu'] .. "\110" .. e['rL0e9B'] .. e[u] .. e[p] ..
                          e[z]]));
        local z = ((n["" .. e[D] .. e[u] .. e[a] .. e[g]]["\108\100\101\120" ..
                      e['rL0e9B']]) or
                      (function(n, e, ...) return ((n * o) ^ e); end));
        P = (c["" .. e[i] .. "\97\110" .. e[S]]) or
                (function(e, n, ...)
                return (((e + n) - t(e, n)) / o);
            end);
        A = ((c["" .. e[B] .. "\115\104\105\102" .. e[a]]) or
                (function(n, e, ...)
                if (e < r) then return (_(n, -(e))); end
                return ((n * o ^ e) % o ^ C);
            end));
        local N = (c["\98\111" .. e[h]]) or
                      (function(n, e, ...)
                return (b - P(b - n, b - e));
            end);
        local b = (c["" .. e[i] .. e[F] .. "\111\116"]) or
                      (function(e, ...) return (b - e); end);
        _ = ((c["\114\115\104\105" .. e[I] .. e[a]]) or (function(n, e, ...)
            if (e < r) then return (A(n, -(e))); end
            return (E(n % o ^ C / o ^ e));
        end));
        if ((not (n["" .. e[i] .. e[m] .. e[a] .. "\51" .. e[J]])) and
            (not (n["" .. e[i] .. "\105\116"]))) then
            c["\98" .. e[u] .. e[F] .. e[S]] = P;
            c["" .. e[i] .. "\111\114"] = N;
            c["\108" .. e[w] .. e[g] .. "\105" .. e[I] .. e[a]] = A;
            c["" .. e[i] .. "\120" .. e[y] .. e[h]] = t;
            c["" .. e[i] .. "\110\111\116"] = b;
            c["" .. e[h] .. e[w] .. e[g] .. e[m] .. "\102" .. e[a]] = _;
        end
        local o =
            (n["" .. e[a] .. e[u] .. "\98" .. e[B] .. "\101"]["" .. e[h] ..
                "\101" .. e[D] .. "\111\118" .. e[s]]);
        local w = (n["" .. e[a] .. "\97\98" .. e[B] .. "\101"]["" .. e[p] ..
                      e[y] .. "\110\99" .. e[u] .. e[a]]);
        local B =
            (((n["\116\97\98\108\101"]["" .. e[p] .. e[h] .. e[s] .. e[u] ..
                "\116\101"])) or
                ((function(e, ...) return ({d({}, r, e)}); end)));
        local o = (n["" .. e[a] .. "\97\98\108\101"]["" .. e[m] .. e[F] ..
                      "\115" .. e[s] .. "\114" .. e[a]]);
        n["" .. e[i] .. e[m] .. e[a] .. "\51\50"] = c;
        local n = ((R + (function()
            local o, n = r, l;
            (function(e) e(e(e)) end)(function(e)
                if o > M then return e end
                o = o + l
                n = (n + q) % O
                if (n % K) >= V then
                    return e
                else
                    return e(e(e))
                end
                return e(e(e and e))
            end)
            return n;
        end)()));
        local a = (#X + Y);
        local c, m = ({}), ({});
        for e = r, a - l do
            local n = Q(e);
            c[e] = n;
            m[e] = n;
            m[n] = e;
        end
        local h, a = (function(o)
            local i, t, e = x(o, l, T);
            if ((i + t + e) ~= W) then
                n = n + H;
                a = a + j;
            end
            o = f(o, G);
            local n, t, i = (""), (""), ({});
            local e = l;
            local function r()
                local n = L(f(o, e, e), ((#{184, 76, 492} + 33)));
                e = e + l;
                local l = L(f(o, e, e + n - l), (36));
                e = e + n;
                return (l);
            end
            n = m[r()];
            i[l] = n;
            while (e < #o) do
                local e = r();
                if c[e] then
                    t = c[e];
                else
                    t = n .. f(n, l, l);
                end
                c[a] = n .. f(t, l, l);
                i[#i + l], n, a = t, t, a + l;
            end
            return (w(i));
        end)(
                         ),
                     (#X - ((209 -
                         #("you dumped constants by printing the deserializer??? ladies and gentlemen stand clear we have a genius in the building."))));
        local function l(e, n, ...)
            if (e == 659203966) then
                return ((t(t((n) - 313447, 584437), 724448)) - 679567);
            elseif (e == 251943735) then
                return ((((n) - 143909) - 457160) - 531429);
            elseif (e == 945569929) then
                return (t(t((t(n, 442588)) - 555712, 16384), 891877));
            elseif (e == 82607332) then
                return (((t(n, 793463)) - 877749) - 664552);
            elseif (e == 901247573) then
                return (t(t(t(n, 255394), 762845), 139368));
            else
            end
        end
        local i = e[(951135582)];
        local w = e[((617967345 - #("Xenvant Likes cock - Perth")))];
        local u = e.a9NnHgBEg;
        local p = e[(494794913)];
        local o = e[(577021787)];
        local g = e[((437382163 -
                      #("I hate this codebase so fucking bad! - notnoobmaster")))];
        local l = e[(547734985)];
        local s = e[((325099188 -
                      #("woooow u hooked an opcode, congratulations~ now suck my cock")))];
        local function r()
            local o, e = x(h, a, a + s);
            o = t(o, n);
            n = o % l;
            e = t(e, n);
            n = e % l;
            a = a + s;
            return ((e * l) + o);
        end
        local function c()
            local c, i, e, o = x(h, a, a + i);
            c = t(c, n);
            n = c % l;
            i = t(i, n);
            n = i % l;
            e = t(e, n);
            n = e % l;
            o = t(o, n);
            n = o % l;
            a = a + u;
            return ((o * p) + (e * w) + (i * l) + c);
        end
        local function i()
            local e = t(x(h, a, a), n);
            n = e % l;
            a = (a + o);
            return (e);
        end
        local function u(l, e, n)
            if (n) then
                local e = (l / s ^ (e - o)) % s ^ ((n - o) - (e - o) + o);
                return (e - (e % o));
            else
                local e = s ^ (e - o);
                return (((l % (e + e) >= e) and (o)) or (g));
            end
        end
        local _ = "\35";
        local function l(...) return ({...}), v(_, ...); end
        local function I(...)
            local g = e["IE0VaF"];
            local k = e[((#{
                (function(...) return 500, 229, 873, 500, ...; end)()
            } + 473803495))];
            local I = e[(471715363)];
            local L = e["qXsTd4yH"];
            local D = e[(87948345)];
            local v = e[((#{
                14, 473, 415, (function(...)
                    return 931, 172, ...;
                end)(268)
            } + 436654076))];
            local F = e[(41982966)];
            local M = e["cb0ihGdPD"];
            local q = e[(504591334)];
            local A = e[(951135582)];
            local w = e[(325099128)];
            local X = e[(118086703)];
            local l = e[((#{646, 511, 894} + 577021784))];
            local J = e[((139063257 -
                          #("you dumped constants by printing the deserializer??? ladies and gentlemen stand clear we have a genius in the building.")))];
            local S = e[(325293112)];
            local P = e[((639811331 -
                          #("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))];
            local Y = e[(115038976)];
            local _ = e[(547734985)];
            local j = e[((#{
                778, 969, 543, 305,
                (function(...) return 504, 999, 271, 807; end)()
            } + 518236464))];
            local o = e[((#{848, 613, 748} + 437382108))];
            local d = e[((532296682 -
                          #("why does psu.dev attract so many ddosing retards wtf")))];
            local p = e.qjiUsxA;
            local C = e.a9NnHgBEg;
            local y = e[(613552666)];
            local function B(...)
                local e = ({});
                local s = ({});
                local b = ({});
                local V = r(n);
                for e = o, c(n) - l, l do b[e] = B(); end
                local H = i(n);
                for r = o, c(n) - l, l do
                    local s = i(n);
                    if (s % d == p) then
                        local n = i(n);
                        e[r] = (n ~= o);
                    elseif (s % d == S) then
                        while (true) do
                            local n = c(n);
                            e[r] = f(h, a, a + n - l);
                            a = a + n;
                            break
                        end
                    elseif (s % d == w) then
                        while (true) do
                            local c = c(n);
                            if (c == o) then
                                e[r] = ('');
                                break
                            end
                            if (c > k) then
                                local o, i = (''), (f(h, a, a + c - l));
                                a = a + c;
                                for e = l, #i, l do
                                    local e = t(x(f(i, e, e)), n);
                                    n = e % _;
                                    o = o .. m[e];
                                end
                                e[r] = o;
                            else
                                local l, o = (''), ({x(h, a, a + c - l)});
                                a = a + c;
                                for o, e in U(o) do
                                    local e = t(e, n);
                                    n = e % _;
                                    l = l .. m[e];
                                end
                                e[r] = l;
                            end
                            break
                        end
                    elseif (s % d == P) then
                        while (true) do
                            local t = c(n);
                            local a = c(n);
                            local c = l;
                            local t = (u(a, l, L) * (w ^ y)) + t;
                            local n = u(a, d, Y);
                            local a = ((-l) ^ u(a, y));
                            if (n == o) then
                                if (t == o) then
                                    e[r] = E(a * o);
                                    break
                                else
                                    n = l;
                                    c = o;
                                end
                            elseif (n == J) then
                                e[r] = (t == o) and (a * (l / o)) or
                                           (a * (o / o));
                                break
                            end
                            local n = z(a, n - X) * (c + (t / (w ^ M)));
                            e[r] = n % l == o and E(n) or n
                            break
                        end
                    else
                        e[r] = nil
                    end
                end
                local a = c(n);
                for e = o, a - l, l do s[e] = ({}); end
                for B = o, a - l, l do
                    local a = i(n);
                    if (a ~= o) then
                        a = a - l;
                        local y, f, m, t, d, x = o, o, o, o, o, o;
                        local h = u(a, l, A);
                        if (h == w) then
                            t = (r(n));
                            x = (i(n));
                            d = s[(c(n))];
                        elseif (h == o) then
                            t = (r(n));
                            x = (i(n));
                            f = (r(n));
                            d = (r(n));
                        elseif (h == A) then
                            t = (r(n));
                            x = (i(n));
                            f = (r(n));
                            d = s[(c(n))];
                        elseif (h == p) then
                        elseif (h == l) then
                            t = (r(n));
                            x = (i(n));
                            d = (c(n));
                        elseif (h == g) then
                            t = (r(n));
                            x = (i(n));
                            f = (r(n));
                            d = (c(n));
                            m = ({});
                            for e = l, f, l do
                                m[e] = ({[o] = i(n), [l] = r(n)});
                            end
                        end
                        if (u(a, C, C) == l) then
                            t = e[t];
                        end
                        if (u(a, g, g) == l) then
                            d = e[d];
                        end
                        if (u(a, p, p) == l) then
                            f = e[f];
                        end
                        if (u(a, D, D) == l) then
                            y = s[c(n)];
                        else
                            y = s[B + l];
                        end
                        if (u(a, F, F) == l) then
                            m = ({});
                            for e = l, i(), l do
                                m[e] = c();
                            end
                        end
                        local e = s[B];
                        e[-236929.76351190906] = y;
                        e[-77613.90522558098] = f;
                        e[-141926.04332059206] = m;
                        e[709897.233080437] = d;
                        e[-31838.49347503646] = t;
                        e[j] = x;
                    end
                end
                return ({
                    [-v] = V,
                    [-q] = b,
                    ["Que0Xa2Y"] = s,
                    ["BCP1C"] = H,
                    [-506361.4523603034] = e,
                    [I] = o
                });
            end
            return (B(...));
        end
        local function x(e, n, c, ...)
            local n = e["Que0Xa2Y"];
            local i = e[-189074];
            local p = e[-268827];
            local l = 0;
            local o = e[-506361.4523603034];
            local t = e["BCP1C"];
            return (function(...)
                local a = 709897.233080437;
                local u = -(1);
                local e = (507519409);
                local h = {};
                local f = n[l];
                local s = {...};
                local l = -31838.49347503646;
                local w = 300045;
                local e = ({});
                local e = (true);
                local m = (v(_, ...) - 1);
                local o = -236929.76351190906;
                local n = {};
                local e = -141926.04332059206;
                local r = -77613.90522558098;
                for e = 0, m, 1 do
                    if (e >= t) then
                        h[e - t] = s[e + 1];
                    else
                        n[e] = s[e + 1];
                    end
                end
                local s = m - t + 1;
                repeat
                    local e = f;
                    local t = e[w];
                    f = e[o];
                    if (t <= 14) then
                        if (t <= 6) then
                            if (t <= 2) then
                                if (t <= 0) then
                                    local l = e[l];
                                    n[l] = n[l](d(n, l + 1, e[a]));
                                    for e = l + 1, i do
                                        n[e] = nil;
                                    end
                                elseif (t == 1) then
                                    local e = e[l];
                                    n[e](n[e + 1]);
                                    for e = e, i do
                                        n[e] = nil;
                                    end
                                elseif (t <= 2) then
                                    c[e[a]] = n[e[l]];
                                end
                            elseif (t <= 4) then
                                if (t == 3) then
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    n[e[l]] = e[a];
                                    e = e[o];
                                    e = e[o];
                                elseif (t <= 4) then
                                    n[e[l]] = n[e[a]];
                                end
                            elseif (t > 5) then
                                e = e[o];
                                local a = e[l];
                                u = a + s - 1;
                                for e = 0, s do
                                    n[a + e] = h[e];
                                end
                                for e = u + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                local l = e[l];
                                do
                                    return d(n, l, u);
                                end
                                e = e[o];
                                e = e[o];
                            elseif (t < 6) then
                                local a = e[a];
                                local o = n[a];
                                for e = a + 1, e[r] do
                                    o = o .. n[e];
                                end
                                n[e[l]] = o;
                            end
                        elseif (t <= 10) then
                            if (t <= 8) then
                                if (t == 7) then
                                    local l = e[l];
                                    u = l + s - 1;
                                    for e = 0, s do
                                        n[l + e] = h[e];
                                    end
                                    for e = u + 1, i do
                                        n[e] = nil;
                                    end
                                elseif (t <= 8) then
                                    local l = e[l];
                                    n[l] = 0 + (n[l]);
                                    n[l + 1] = 0 + (n[l + 1]);
                                    n[l + 2] = 0 + (n[l + 2]);
                                    local o = n[l];
                                    local t = n[l + 2];
                                    if (t > 0) then
                                        if (o > n[l + 1]) then
                                            f = e[a];
                                        else
                                            n[l + 3] = o;
                                        end
                                    elseif (o < n[l + 1]) then
                                        f = e[a];
                                    else
                                        n[l + 3] = o;
                                    end
                                end
                            elseif (t > 9) then
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                local t = e[l];
                                n[t] = n[t](d(n, t + 1, e[a]));
                                for e = t + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                c[e[a]] = n[e[l]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = n[e[a]][e[r]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                local t = e[l];
                                n[t] = n[t](d(n, t + 1, e[a]));
                                for e = t + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                c[e[a]] = n[e[l]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = n[e[a]][e[r]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                local t = e[l];
                                n[t] = n[t](d(n, t + 1, e[a]));
                                for e = t + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                                c[e[a]] = n[e[l]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = n[e[a]][e[r]];
                                e = e[o];
                                n[e[l]] = c[e[a]];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                e = e[o];
                            elseif (t < 10) then
                                n[e[l]] = B(e[a]);
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                e = e[o];
                            end
                        elseif (t <= 12) then
                            if (t == 11) then
                                n[e[l]] = e[a];
                            elseif (t <= 12) then
                                local l = e[l];
                                local t = n[l + 2];
                                local o = n[l] + t;
                                n[l] = o;
                                if (t > 0) then
                                    if (o <= n[l + 1]) then
                                        f = e[a];
                                        n[l + 3] = o;
                                    end
                                elseif (o >= n[l + 1]) then
                                    f = e[a];
                                    n[l + 3] = o;
                                end
                            end
                        elseif (t > 13) then
                            n[e[l]] = c[e[a]];
                        elseif (t < 14) then
                            n[e[l]] = n[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t](n[t + 1]);
                            for e = t, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](n[t + 1]);
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            c[e[a]] = n[e[l]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            c[e[a]] = n[e[l]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            c[e[a]] = n[e[l]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            e = e[o];
                        end
                    elseif (t <= 22) then
                        if (t <= 18) then
                            if (t <= 16) then
                                if (t > 15) then
                                    do
                                        return;
                                    end
                                elseif (t < 16) then
                                    local l = e[l];
                                    n[l](d(n, l + 1, e[a]));
                                    for e = l + 1, i do
                                        n[e] = nil;
                                    end
                                end
                            elseif (t > 17) then
                                local e = e[l];
                                n[e] = n[e](n[e + 1]);
                                for e = e + 1, i do
                                    n[e] = nil;
                                end
                            elseif (t < 18) then
                                n[e[l]] = #n[e[a]];
                            end
                        elseif (t <= 20) then
                            if (t == 19) then
                                n[e[l]] = n[e[a]][e[r]];
                            elseif (t <= 20) then
                                n[e[l]] = x(p[e[a]], (nil), c);
                            end
                        elseif (t == 21) then
                        elseif (t <= 22) then
                            n[e[l]] = B(e[a]);
                        end
                    elseif (t <= 26) then
                        if (t <= 24) then
                            if (t > 23) then
                                n[e[l]] = B(256);
                            elseif (t < 24) then
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                n[e[l]] = e[a];
                                e = e[o];
                                e = e[o];
                            end
                        elseif (t > 25) then
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local l = e[l];
                            n[l](n[l + 1]);
                            for e = l, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            e = e[o];
                        elseif (t < 26) then
                            n[e[l]] = n[e[a]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = c[e[a]];
                            e = e[o];
                            n[e[l]] = n[e[a]][e[r]];
                            e = e[o];
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = (_72);
                            (function()
                                n[e[l]] = #n[e[a]];
                                e = e[o];
                            end) {};
                            local t = e[l];
                            n[t] = n[t](d(n, t + 1, e[a]));
                            for e = t + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            n[e[l]] = n[e[a]][n[e[r]]];
                            e = e[o];
                            local t = (_119);
                            (function()
                                local l = e[l];
                                n[l] = n[l](n[l + 1]);
                                for e = l + 1, i do
                                    n[e] = nil;
                                end
                                e = e[o];
                            end) {};
                            n[e[l]] = e[a];
                            e = e[o];
                            local t = (_127);
                            (function()
                                local t = e[a];
                                local a = n[t];
                                for e = t + 1, e[r] do
                                    a = a .. n[e];
                                end
                                n[e[l]] = a;
                                e = e[o];
                            end) {};
                            local l = e[l];
                            n[l](d(n, l + 1, e[a]));
                            for e = l + 1, i do
                                n[e] = nil;
                            end
                            e = e[o];
                            e = e[o];
                        end
                    elseif (t <= 28) then
                        if (t == 27) then
                            local e = e[l];
                            do return d(n, e, u); end
                        elseif (t <= 28) then
                            local l = e[l];
                            local o = e[a];
                            local a = 50 * (e[r] - 1);
                            local t = n[l];
                            local e = 0;
                            for o = l + 1, o do
                                t[a + e + 1] = n[l + (o - l)];
                                e = e + 1;
                            end
                        end
                    elseif (t > 29) then
                        local t = (_152);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_102);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_143);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_28);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_46);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_7);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_127);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_40);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_44);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_16);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_95);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_109);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_164);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_50);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_73);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_186);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_122);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_16);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_15);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_178);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_60);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_20);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_71);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        local t = (_111);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        n[e[l]] = e[a];
                        e = e[o];
                        local t = (_57);
                        (function()
                            n[e[l]] = e[a];
                            e = e[o];
                        end) {};
                        n[e[l]] = e[a];
                        e = e[o];
                        e = e[o];
                    elseif (t < 30) then
                        n[e[l]] = n[e[a]][n[e[r]]];
                    end
                until false
            end);
        end
        return x(I(), {}, k())(...);
    end)(({
        ["tbQAnSd"] = (((3302 - #("The Voxel is sus")))),
        [((#{298, 297, (function(...) return 429, 846, 295, 269; end)()} +
            532296624))] = (((#{(function(...) return; end)()} + 21))),
        [((313180705 - #("Xenvant Likes cock - Perth")))] = ((121)),
        [(275270722)] = (((#{
            757, 86, (function(...) return 140, 443, 166; end)()
        } + 867755188))),
        [((196684538 -
            #("luraph is now down until further notice for an emergency major security update")))] = ("\114"),
        [(515894356)] = ("\104"),
        [((78336370 - #("I hate this codebase so fucking bad! - notnoobmaster")))] = ((284902844)),
        [(510671477)] = ("\111"),
        ['a9NnHgBEg'] = (((#{181, 800} + 2))),
        [((#{815, 841, 399, 888, (function(...) return ...; end)()} + 980966418))] = ("\98"),
        [((#{427, 569, 12, (function(...) return 644, 861, 759; end)()} +
            248904558))] = ((980966422)),
        [(473803499)] = ((5000)),
        [((#{325, 254, 933, 582, (function(...) return 271, 635; end)()} +
            867755187))] = ("\110"),
        [((#{649, 332, 598, (function(...) return; end)()} + 951135579))] = (((41 -
            #("psu 34567890fps, luraph 1fps, xen 0fps")))),
        ["qXsTd4yH"] = (((99 -
            #("Are you using AztupBrew, clvbrew, or IB2? Congratulations! You're deobfuscated!")))),
        [((#{881, 102, 315, 78} + 408839042))] = ((113095730)),
        [(547734985)] = (((#{124, 124, 655, 809} + 252))),
        ['rL0e9B'] = ("\112"),
        [((#{338, 842, 487} + 13178423))] = ("\99"),
        [((205055820 -
            #("psu premium chads winning (only joe biden supporters use the free version)")))] = (((186 -
            #("psu == femboy hangout")))),
        [(471715363)] = ((359958)),
        [((639811321 -
            #("uh oh everyone watch out pain exist coming in with the backspace method one dot two dot man dot")))] = (((69 -
            #("LuraphDeobfuscator.zip (oh god DMCA incoming everyone hide)")))),
        [((#{
            155, 960, 947,
            (function(...) return 529, 169, ...; end)(986, 609, 229, 128)
        } + 504591325))] = (((#{165, 127, 862} + 268824))),
        ["JcRPcu"] = ("\117"),
        [(884195142)] = (((667505821 -
            #("oh Mr. Pools, thats a little close please dont touch me there... please Mr. Pools I am only eight years old please stop...")))),
        [((46910795 -
            #("I'm not ignoring you, my DMs are full. Can't DM me? Shoot me a email: mem@mem.rip (Business enquiries only)")))] = ((78)),
        [(728893204)] = ("\115"),
        [((659868525 - #("still waiting for luci to fix the API :|")))] = ((555)),
        [((474781470 - #("The Voxel is sus")))] = ("\108"),
        [(87948345)] = ((8)),
        [((613091878 -
            #("@everyone designs are done. luraph website coming.... eta JULY 2020")))] = ("\116"),
        [(577021787)] = (((#{
            843, (function(...) return 278, 380, 544, ...; end)(781, 877)
        } - 5))),
        [(787317128)] = ((36)),
        [(223949360)] = (((337479154 -
            #("Luraph: Probably considered the worst out of the three, Luraph is another Lua Obfuscator. It isnt remotely as secure as Ironbrew or Synapse Xen, and it isn't as fast as Ironbrew either.")))),
        [(314133589)] = ((196684460)),
        [((613552733 -
            #("i am not wally stop asking me for wally hub support please fuck off")))] = ((32)),
        [((458218296 -
            #("Are you using AztupBrew, clvbrew, or IB2? Congratulations! You're deobfuscated!")))] = ((613091811)),
        [(153157513)] = (((515894408 -
            #("I hate this codebase so fucking bad! - notnoobmaster")))),
        [(494794913)] = ((16777216)),
        [(115038976)] = (((67 - #("If you see this, congrats you're gay")))),
        [((23441594 - #("If you see this, congrats you're gay")))] = ((63916755)),
        [(325099128)] = ((2)),
        [(337478969)] = ("\105"),
        PVyDQN2X9 = ((61)),
        [((63916771 - #("The Voxel is sus")))] = ("\101"),
        [((#{234, 861} + 518236470))] = (((300164 -
            #("you dumped constants by printing the deserializer??? ladies and gentlemen stand clear we have a genius in the building.")))),
        [(437382111)] = (((#{931, 480} - 2))),
        [(139063138)] = ((2047)),
        [((#{704, 804, 661, 812} + 118086699))] = ((1023)),
        [((#{326, 366, (function(...) return 17, 479, 616, 206; end)()} +
            279333740))] = (((588406153 -
            #("luraph is now down until further notice for an emergency major security update")))),
        [((90524778 -
            #("PSU|161027525v21222B11273172751L275102731327523d27f22I27f21o26o24Y21J1827F1X27f1r27F23823a26w1... oh wait")))] = ("\50"),
        [((#{722} + 616272188))] = (((90524716 -
            #("https://www.youtube.com/watch?v=Lrj2Hq7xqQ8")))),
        ['HmESj'] = ((474781454)),
        [((86863523 -
            #("Are you using AztupBrew, clvbrew, or IB2? Congratulations! You're deobfuscated!")))] = ((90)),
        [(113095730)] = ("\107"),
        cb0ihGdPD = (((67 - #("concat was here")))),
        [(41982966)] = ((7)),
        ['IE0VaF'] = ((5)),
        [(80086535)] = ((298)),
        [((#{546, 607, (function(...) return 851; end)()} + 436654079))] = (((#{
            437
        } + 189073))),
        [(573502982)] = (((#{31, 150} + 13178424))),
        [(284902844)] = ("\102"),
        H29J4aP40 = (((#{454} + 247))),
        [((325293234 -
            #("oh Mr. Pools, thats a little close please dont touch me there... please Mr. Pools I am only eight years old please stop...")))] = (((80 -
            #("why the fuck would we sell a deobfuscator for a product we created.....")))),
        [(617967319)] = (((#{
            654, 650, 858, 739, (function(...) return 82, 389, 545; end)()
        } + 65529))),
        [(783148520)] = (((470 -
            #("psu premium chads winning (only joe biden supporters use the free version)")))),
        [((#{968, 644, 847, 560} + 910167602))] = ((492137244)),
        ['qjiUsxA'] = (((113 -
            #("I'm not ignoring you, my DMs are full. Can't DM me? Shoot me a email: mem@mem.rip (Business enquiries only)")))),
        [((#{800, (function(...) return; end)()} + 492137243))] = ("\97"),
        [((#{600, 65, 409, (function(...) return 913, 207, 397; end)()} +
            685154760))] = ((510671477)),
        [(588406075)] = ("\100"),
        [((#{183, 553, 570} + 915113775))] = (((#{
            525, (function(...) return 942; end)()
        } + 1108))),
        [(955119521)] = ((728893204)),
        [(667505699)] = ("\109")
    }), ...)
}) do return e end
