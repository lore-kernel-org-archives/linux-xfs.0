Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Mar 2007 09:49:19 -0700 (PDT)
Received: from ipmail03.adl2.internode.on.net (ipmail03.adl2.internode.on.net [203.16.214.135])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2EGnA6p021728
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2007 09:49:13 -0700
Subject: Re: Questions about XFS
From: Stewart Smith <stewart@flamingspork.com>
In-Reply-To: <200703131440.56678.clflush@chello.be>
References: <200703131440.56678.clflush@chello.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PipK4s1B2QL96SKgRJBZ"
Date: Wed, 14 Mar 2007 17:33:36 +0100
Message-Id: <1173890016.20671.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: clflush <clflush@chello.be>
Cc: xfs@oss.sgi.com

--=-PipK4s1B2QL96SKgRJBZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-13 at 14:40 +0100, clflush wrote:
> I have a few simple questions regarding the XFS file system. I built a ne=
w=20
> small server here (commodity hardware, x86-64) and I've installed 32-bit=
=20
> openSUSE 10.2 on it. After the system was installed, configured and up an=
d=20
> running, it hung while I was browsing with Firefox. The only thing I coul=
d do=20
> was to press the reset button on the computer. After the reboot, when I=
=20
> opened Firefox again, I noticed that all my bookmarks were gone. Those=20
> bookmarks were imported from my desktop machine a few days after I config=
ured=20
> the new server.

This is a firefox bug - I've seen it before (on my mother's machine).

It's due to firefox not doing the correct thing with IO on the bookmarks
file.

As mentioned in another mail you can restore from a backup that firefox
makes.

In a future release, firefox is going to be using sqlite for storing
thes ethings, which will mean that these problems go away (pretty sure
sqllite does all the right things)
--=20
Stewart Smith (stewart@flamingspork.com)
http://www.flamingspork.com/


--=-PipK4s1B2QL96SKgRJBZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBF+CPgKglWCUL+FDoRAvkMAJ0V6pPr9mHHJzt1FrNMKMJHhdEDUACeKk2C
4qkOj4rKEA9M8/Q2fZrA/6E=
=MJqH
-----END PGP SIGNATURE-----

--=-PipK4s1B2QL96SKgRJBZ--
