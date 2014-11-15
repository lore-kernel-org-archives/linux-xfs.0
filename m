Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E37A7F57
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 20:17:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A48448F8039
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 18:17:42 -0800 (PST)
Received: from BLU004-OMC3S5.hotmail.com (blu004-omc3s5.hotmail.com
	[65.55.116.80]) by cuda.sgi.com with ESMTP id ExPcE4zFPTZpvwuV
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Nov 2014 18:17:40 -0800 (PST)
Message-ID: <BLU172-W19A7DE957502A2F854163FC48D0@phx.gbl>
From: Robert Tench <robtench@hotmail.com>
Subject: RE: Mismatch UUID
Date: Sat, 15 Nov 2014 13:17:39 +1100
In-Reply-To: <546692DA.9040105@sandeen.net>
References: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
	<6AB68617-0884-486D-8B96-8FD22DBC76D1@colorremedies.com>,
	<546692DA.9040105@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4707771508125435683=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Chris Murphy <lists@colorremedies.com>, Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4707771508125435683==
Content-Type: multipart/alternative;
	boundary="_11767b43-37f7-42b5-a31a-efa393c893ba_"

--_11767b43-37f7-42b5-a31a-efa393c893ba_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi all=2C

Many thanks for the replies so far.

So here is the reponse from the command line mdadm -E /dev/sd[abcde]2

ubuntu@ubuntu:~$ sudo mdadm -E /dev/sd[abcde]2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : e0829810:9782b51f:25529f65:8823419c
           Name : (none):4
  Creation Time : Fri Jan  1 01:31:17 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5856481280 (2792.59 GiB 2998.52 GB)
     Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
   Super Offset : 5856481536 sectors
          State : clean
    Device UUID : d405d0c5:2a07d7ed:27abcb5a:0eeadc7d

    Update Time : Fri Nov 14 15:58:16 2014
       Checksum : c082e9bb - correct
         Events : 1243386

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' =3D=3D active=2C '.' =3D=3D missing)
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : e0829810:9782b51f:25529f65:8823419c
           Name : (none):4
  Creation Time : Fri Jan  1 01:31:17 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5856481280 (2792.59 GiB 2998.52 GB)
     Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
   Super Offset : 5856481536 sectors
          State : clean
    Device UUID : 33acf23a:52a0ad00:cda69d9f:468a8c13

    Update Time : Fri Nov 14 15:58:16 2014
       Checksum : 22fdc525 - correct
         Events : 1243386

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA ('A' =3D=3D active=2C '.' =3D=3D missing)
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : e0829810:9782b51f:25529f65:8823419c
           Name : (none):4
  Creation Time : Fri Jan  1 01:31:17 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5856481280 (2792.59 GiB 2998.52 GB)
     Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
   Super Offset : 5856481536 sectors
          State : clean
    Device UUID : 1a4f20e2:34926568:af5351a1:9c9f60e9

    Update Time : Fri Nov 14 15:58:16 2014
       Checksum : 96b21ac - correct
         Events : 1243386

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' =3D=3D active=2C '.' =3D=3D missing)
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : e0829810:9782b51f:25529f65:8823419c
           Name : (none):4
  Creation Time : Fri Jan  1 01:31:17 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5856481280 (2792.59 GiB 2998.52 GB)
     Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
   Super Offset : 5856481536 sectors
          State : clean
    Device UUID : 0ee6b711:242fbd18:44c2839e:60e8ad0d

    Update Time : Fri Nov 14 15:58:16 2014
       Checksum : ada0762 - correct
         Events : 1243386

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA ('A' =3D=3D active=2C '.' =3D=3D missing)
/dev/sde2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : e0829810:9782b51f:25529f65:8823419c
           Name : (none):4
  Creation Time : Fri Jan  1 01:31:17 2010
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5856481280 (2792.59 GiB 2998.52 GB)
     Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
   Super Offset : 5856481536 sectors
          State : clean
    Device UUID : f89fdd4c:627a6650:3de0dcab:6790076f

    Update Time : Fri Nov 14 15:58:16 2014
       Checksum : ec5bd289 - correct
         Events : 1243386

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' =3D=3D active=2C '.' =3D=3D missing)


What I am curious about is how I should go about attempting to Mount the de=
vice and the command line needed. Am I mounting the Raid Array /dev/md4=2C =
or am I trying to mount the XFS data partitions contained within with would=
 be made up of /dev/sd[abcde2]? I am a little bit confused by all the vario=
us options and what I am exactly suppose to use given being a complete linu=
x novice.

Any help is appreciated?

Rob


> Date: Fri=2C 14 Nov 2014 17:40:10 -0600
> From: sandeen@sandeen.net
> To: lists@colorremedies.com=3B robtench@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: Mismatch UUID
>=20
> On 11/14/14 4:31 PM=2C Chris Murphy wrote:
>=20
> > It=92s very good to ask instead of haphazardly trying things. Trying to
> > normally mount the file system should be safe=3B and then use dmesg to
> > check for kernel messages. The xfs kernel code is responsible for log
> > replay and making most kinds of repairs=2C anything it can=92t deal wit=
h
> > will be reported as a kernel message. If mount fails=2C report kernel
> > xfs related messages=2C and also the results from xfs_check -n.
>=20
> xfs_repair -n
>=20
> xfs_check is deprecated and has no -n option =3B)
>=20
> -Eric
 		 	   		  =

--_11767b43-37f7-42b5-a31a-efa393c893ba_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>Hi all=2C<br><br>Many thanks for=
 the replies so far.<br><br>So here is the reponse from the command line md=
adm -E /dev/sd[abcde]2<br><br>ubuntu@ubuntu:~$ sudo mdadm -E /dev/sd[abcde]=
2<br>/dev/sda2:<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B Magic : a92b4efc<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Version : 1.0<br>&nbsp=3B&nbsp=3B&nbsp=3B Feature Map :=
 0x0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Array UUID : e0829810:9782b51f:255=
29f65:8823419c<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B Name : (none):4<br>&nbsp=3B Creation Time : Fri Jan=
&nbsp=3B 1 01:31:17 2010<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Raid Level : r=
aid5<br>&nbsp=3B&nbsp=3B Raid Devices : 5<br><br>&nbsp=3BAvail Dev Size : 5=
856481280 (2792.59 GiB 2998.52 GB)<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Arra=
y Size : 11712962560 (11170.35 GiB 11994.07 GB)<br>&nbsp=3B&nbsp=3B Super O=
ffset : 5856481536 sectors<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B State : clean<br>&nbsp=3B&nbsp=3B&nbsp=3B Devic=
e UUID : d405d0c5:2a07d7ed:27abcb5a:0eeadc7d<br><br>&nbsp=3B&nbsp=3B&nbsp=
=3B Update Time : Fri Nov 14 15:58:16 2014<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Checksum : c082e9bb - correct<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Events : 1243386<br><br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Layout : left-s=
ymmetric<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Chunk Size : 512K<br><br>&nbsp=
=3B&nbsp=3B Device Role : Active device 0<br>&nbsp=3B&nbsp=3B Array State :=
 AAAAA ('A' =3D=3D active=2C '.' =3D=3D missing)<br>/dev/sdb2:<br>&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Magic : a92=
b4efc<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Version :=
 1.0<br>&nbsp=3B&nbsp=3B&nbsp=3B Feature Map : 0x0<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Array UUID : e0829810:9782b51f:25529f65:8823419c<br>&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Name =
: (none):4<br>&nbsp=3B Creation Time : Fri Jan&nbsp=3B 1 01:31:17 2010<br>&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Raid Level : raid5<br>&nbsp=3B&nbsp=3B Raid=
 Devices : 5<br><br>&nbsp=3BAvail Dev Size : 5856481280 (2792.59 GiB 2998.5=
2 GB)<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Array Size : 11712962560 (11170.3=
5 GiB 11994.07 GB)<br>&nbsp=3B&nbsp=3B Super Offset : 5856481536 sectors<br=
>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B S=
tate : clean<br>&nbsp=3B&nbsp=3B&nbsp=3B Device UUID : 33acf23a:52a0ad00:cd=
a69d9f:468a8c13<br><br>&nbsp=3B&nbsp=3B&nbsp=3B Update Time : Fri Nov 14 15=
:58:16 2014<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Checksum : =
22fdc525 - correct<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Events : 1243386<br><br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Layout : left-symmetric<br>&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B Chunk Size : 512K<br><br>&nbsp=3B&nbsp=3B Device Role : Active=
 device 1<br>&nbsp=3B&nbsp=3B Array State : AAAAA ('A' =3D=3D active=2C '.'=
 =3D=3D missing)<br>/dev/sdc2:<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Magic : a92b4efc<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Version : 1.0<br>&nbsp=3B&nbsp=3B&nbsp=
=3B Feature Map : 0x0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Array UUID : e082=
9810:9782b51f:25529f65:8823419c<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Name : (none):4<br>&nbsp=3B Creati=
on Time : Fri Jan&nbsp=3B 1 01:31:17 2010<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Raid Level : raid5<br>&nbsp=3B&nbsp=3B Raid Devices : 5<br><br>&nbsp=3B=
Avail Dev Size : 5856481280 (2792.59 GiB 2998.52 GB)<br>&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B Array Size : 11712962560 (11170.35 GiB 11994.07 GB)<br>&nbsp=
=3B&nbsp=3B Super Offset : 5856481536 sectors<br>&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B State : clean<br>&nbsp=3B&nb=
sp=3B&nbsp=3B Device UUID : 1a4f20e2:34926568:af5351a1:9c9f60e9<br><br>&nbs=
p=3B&nbsp=3B&nbsp=3B Update Time : Fri Nov 14 15:58:16 2014<br>&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Checksum : 96b21ac - correct<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Events : 124338=
6<br><br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B L=
ayout : left-symmetric<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Chunk Size : 512=
K<br><br>&nbsp=3B&nbsp=3B Device Role : Active device 2<br>&nbsp=3B&nbsp=3B=
 Array State : AAAAA ('A' =3D=3D active=2C '.' =3D=3D missing)<br>/dev/sdd2=
:<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B Magic : a92b4efc<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B Version : 1.0<br>&nbsp=3B&nbsp=3B&nbsp=3B Feature Map : 0x0<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Array UUID : e0829810:9782b51f:25529f65:8823419=
c<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B Name : (none):4<br>&nbsp=3B Creation Time : Fri Jan&nbsp=3B 1 0=
1:31:17 2010<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Raid Level : raid5<br>&nbs=
p=3B&nbsp=3B Raid Devices : 5<br><br>&nbsp=3BAvail Dev Size : 5856481280 (2=
792.59 GiB 2998.52 GB)<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Array Size : 117=
12962560 (11170.35 GiB 11994.07 GB)<br>&nbsp=3B&nbsp=3B Super Offset : 5856=
481536 sectors<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B State : clean<br>&nbsp=3B&nbsp=3B&nbsp=3B Device UUID : 0ee=
6b711:242fbd18:44c2839e:60e8ad0d<br><br>&nbsp=3B&nbsp=3B&nbsp=3B Update Tim=
e : Fri Nov 14 15:58:16 2014<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B Checksum : ada0762 - correct<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B Events : 1243386<br><br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Layout : left-symmetric<br>&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B Chunk Size : 512K<br><br>&nbsp=3B&nbsp=3B Devi=
ce Role : Active device 3<br>&nbsp=3B&nbsp=3B Array State : AAAAA ('A' =3D=
=3D active=2C '.' =3D=3D missing)<br>/dev/sde2:<br>&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Magic : a92b4efc<br>&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Version : 1.0<br>&nbsp=
=3B&nbsp=3B&nbsp=3B Feature Map : 0x0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B A=
rray UUID : e0829810:9782b51f:25529f65:8823419c<br>&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Name : (none):4<br=
>&nbsp=3B Creation Time : Fri Jan&nbsp=3B 1 01:31:17 2010<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B Raid Level : raid5<br>&nbsp=3B&nbsp=3B Raid Devices : 5=
<br><br>&nbsp=3BAvail Dev Size : 5856481280 (2792.59 GiB 2998.52 GB)<br>&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B Array Size : 11712962560 (11170.35 GiB 11994.=
07 GB)<br>&nbsp=3B&nbsp=3B Super Offset : 5856481536 sectors<br>&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B State : clean=
<br>&nbsp=3B&nbsp=3B&nbsp=3B Device UUID : f89fdd4c:627a6650:3de0dcab:67900=
76f<br><br>&nbsp=3B&nbsp=3B&nbsp=3B Update Time : Fri Nov 14 15:58:16 2014<=
br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Checksum : ec5bd289 - c=
orrect<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B =
Events : 1243386<br><br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B Layout : left-symmetric<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B C=
hunk Size : 512K<br><br>&nbsp=3B&nbsp=3B Device Role : Active device 4<br>&=
nbsp=3B&nbsp=3B Array State : AAAAA ('A' =3D=3D active=2C '.' =3D=3D missin=
g)<br><br><br><div>What I am curious about is how I should go about attempt=
ing to Mount the device and the command line needed. Am I mounting the Raid=
 Array /dev/md4=2C or am I trying to mount the XFS data partitions containe=
d within with would be made up of /dev/sd[abcde2]? I am a little bit confus=
ed by all the various options and what I am exactly suppose to use given be=
ing a complete linux novice.<br><br>Any help is appreciated?<br><br>Rob<br>=
<br><br>&gt=3B Date: Fri=2C 14 Nov 2014 17:40:10 -0600<br>&gt=3B From: sand=
een@sandeen.net<br>&gt=3B To: lists@colorremedies.com=3B robtench@hotmail.c=
om<br>&gt=3B CC: xfs@oss.sgi.com<br>&gt=3B Subject: Re: Mismatch UUID<br>&g=
t=3B <br>&gt=3B On 11/14/14 4:31 PM=2C Chris Murphy wrote:<br>&gt=3B <br>&g=
t=3B &gt=3B It=92s very good to ask instead of haphazardly trying things. T=
rying to<br>&gt=3B &gt=3B normally mount the file system should be safe=3B =
and then use dmesg to<br>&gt=3B &gt=3B check for kernel messages. The xfs k=
ernel code is responsible for log<br>&gt=3B &gt=3B replay and making most k=
inds of repairs=2C anything it can=92t deal with<br>&gt=3B &gt=3B will be r=
eported as a kernel message. If mount fails=2C report kernel<br>&gt=3B &gt=
=3B xfs related messages=2C and also the results from xfs_check -n.<br>&gt=
=3B <br>&gt=3B xfs_repair -n<br>&gt=3B <br>&gt=3B xfs_check is deprecated a=
nd has no -n option =3B)<br>&gt=3B <br>&gt=3B -Eric<br></div> 		 	   		  </=
div></body>
</html>=

--_11767b43-37f7-42b5-a31a-efa393c893ba_--


--===============4707771508125435683==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4707771508125435683==--
