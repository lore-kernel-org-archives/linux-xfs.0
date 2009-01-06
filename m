Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0683Bfr028816 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 02:03:11 -0600
Received: from bay0-omc3-s18.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 579A717AF543
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 00:03:09 -0800 (PST)
Received: from bay0-omc3-s18.bay0.hotmail.com (bay0-omc3-s18.bay0.hotmail.com
	[65.54.246.218]) by cuda.sgi.com with ESMTP id 2ls4NxfPFNnXrMA8
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2009 00:03:09 -0800 (PST)
Message-ID: <BAY123-W41D72B924FD31C7FE4A93DEADE0@phx.gbl>
From: Tritium Tritium <tritium_helium@hotmail.com>
Subject: RE: retrocompatibility XFS 2.10.1 with 2.8.1 ?
Date: Tue, 6 Jan 2009 08:03:09 +0000
In-Reply-To: <20090106011014.GA9448@disturbed>
References: <BAY123-W145701C4842C1B063295BDEAE10@phx.gbl>
	<20090106011014.GA9448@disturbed>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8438880645738931389=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

--===============8438880645738931389==
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-length: 1925


Thanks for you response !

unfortunately , I don't know the kernel version of my Adsl Box .
I search in documentation and I don't find any item about a parameter which=
 take a compatibility with old xfs support .

Thanks and I hope see you later !
Vince.

> Date: Tue, 6 Jan 2009 12:10:14 +1100
> From: david@fromorbit.com
> To: tritium_helium@hotmail.com
> CC: xfs@oss.sgi.com
> Subject: Re: retrocompatibility XFS 2.10.1 with 2.8.1 ?
>=20
> On Mon, Jan 05, 2009 at 07:04:30PM +0000, Tritium Tritium wrote:
> >=20
> > HI !
> >=20
> > In first, I 'm a french user and sorry for my very bad english ...
> > For an Adsl Box, I want to partitionning and format my external hard di=
sk drive under XFS .What a good idea , isn't it ? ;o)
> > I get my Mandriva One (I know it isn't a "professionnal" distribution b=
ut you know the French search the simple thing !) and use fdisk -l , gparte=
d and mkfs.xfs /dev/xxx .
> > With this, the adsl box reboot ! And of course it doesn't recognize the=
 partition.
> > I tried with a Debian Etch XFS ... and this is a SUCCESS !
> > When I compare XFS versions I find a 2.10.1 for Mandriva and 2.8.1 for =
Debian.
>=20
> The defaults mkfs.xfs uses in 2.10.1 are different to 2.8.1. The
> newer version enables features that are only availble in more recent
> kernels (since about 2.6.19, IIRC), so it would seem that your ADSL
> box has an old kernel on it that does not support the newer, faster,
> shinier features XFS has....
>=20
> The kernel version of your ADSL box, as well as the mkfs.xfs output
> from both distro's would help confirm this.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

_________________________________________________________________
T=E9l=E9phonez gratuitement =E0 tous vos proches avec Windows Live Messenge=
r=A0 !=A0 T=E9l=E9chargez-le maintenant !
http://www.windowslive.fr/messenger/1.asp

[[HTML alternate version deleted]]


--===============8438880645738931389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8438880645738931389==--
