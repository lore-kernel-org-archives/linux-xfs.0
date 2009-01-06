Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0686Eab029033 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 02:06:14 -0600
Received: from bay0-omc1-s20.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8AF017AF59D
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 00:06:12 -0800 (PST)
Received: from bay0-omc1-s20.bay0.hotmail.com (bay0-omc1-s20.bay0.hotmail.com
	[65.54.246.92]) by cuda.sgi.com with ESMTP id qENCcjADoulak8aQ
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2009 00:06:12 -0800 (PST)
Message-ID: <BAY123-W52A2C4DA5198843FEB917FEADE0@phx.gbl>
From: Tritium Tritium <tritium_helium@hotmail.com>
Subject: RE: retrocompatibility XFS 2.10.1 with 2.8.1 ?
Date: Tue, 6 Jan 2009 08:06:11 +0000
In-Reply-To: <CA02FD05-723D-4F8E-8DDC-E9AFC8AF790A@sandeen.net>
References: <BAY123-W145701C4842C1B063295BDEAE10@phx.gbl>
	<20090106011014.GA9448@disturbed>
	<CA02FD05-723D-4F8E-8DDC-E9AFC8AF790A@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5620050503933648902=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net, david@fromorbit.com
Cc: xfs@oss.sgi.com

--===============5620050503933648902==
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-length: 2500


It's mad ...
It isn't any messages in dmesg output !
Only the mkfs output messages in the command line ...

"For what it's worth, you can just turn off the newer features when you  mk=
fs with the newer version, too"
How can I disable the new features ?

Thanks for your interst !


> From: sandeen@sandeen.net
> To: david@fromorbit.com
> Subject: Re: retrocompatibility XFS 2.10.1 with 2.8.1 ?
> Date: Mon, 5 Jan 2009 22:44:51 -0600
> CC: tritium_helium@hotmail.com; xfs@oss.sgi.com
>=20
>=20
>=20
> On Jan 5, 2009, at 7:10 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> > On Mon, Jan 05, 2009 at 07:04:30PM +0000, Tritium Tritium wrote:
> >>
> >> HI !
> >>
> >> In first, I 'm a french user and sorry for my very bad english ...
> >> For an Adsl Box, I want to partitionning and format my external=20=20
> >> hard disk drive under XFS .What a good idea , isn't it ? ;o)
> >> I get my Mandriva One (I know it isn't a "professionnal"=20=20
> >> distribution but you know the French search the simple thing !) and=20=
=20
> >> use fdisk -l , gparted and mkfs.xfs /dev/xxx .
> >> With this, the adsl box reboot ! And of course it doesn't recognize=20=
=20
> >> the partition.
> >> I tried with a Debian Etch XFS ... and this is a SUCCESS !
> >> When I compare XFS versions I find a 2.10.1 for Mandriva and 2.8.1=20=
=20
> >> for Debian.
> >
> > The defaults mkfs.xfs uses in 2.10.1 are different to 2.8.1. The
> > newer version enables features that are only availble in more recent
> > kernels (since about 2.6.19, IIRC), so it would seem that your ADSL
> > box has an old kernel on it that does not support the newer, faster,
> > shinier features XFS has....
> >
> > The kernel version of your ADSL box, as well as the mkfs.xfs output
> > from both distro's would help confirm this.
>=20
> dmesg output after the failed mount would hopefully also offer some=20=20
> clues..
>=20
> For what it's worth, you can just turn off the newer features when you=20=
=20
> mkfs with the newer version, too.
>=20
> -Eric
>=20
> >
> > Cheers,
> >
> > Dave.
> > --=20
> > Dave Chinner
> > david@fromorbit.com
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >

_________________________________________________________________
In=E9dit ! Des Emotic=F4nes D=E9jant=E9es! Installez les dans votre Messeng=
er !=20
http://www.ilovemessenger.fr/Emoticones/EmoticonesDejantees.aspx

[[HTML alternate version deleted]]


--===============5620050503933648902==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5620050503933648902==--
