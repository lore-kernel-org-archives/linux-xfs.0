Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n217x54i144744 for <xfs@oss.sgi.com>; Sun, 1 Mar 2009 01:59:06 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 965A816178A
	for <xfs@oss.sgi.com>; Sat, 28 Feb 2009 23:58:30 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id zjbhTYNmDAnGuIPc for
	<xfs@oss.sgi.com>; Sat, 28 Feb 2009 23:58:30 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Sun, 1 Mar 2009 02:58:27 -0500
References: <200902240010.25434.vapier@gentoo.org>
	<200902271055.51564.agruen@suse.de> <49A9E555.7040607@sgi.com>
In-Reply-To: <49A9E555.7040607@sgi.com>
MIME-Version: 1.0
Message-Id: <200903010258.28930.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3645944816973395896=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Greg Banks <gnb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>

--===============3645944816973395896==
Content-Type: multipart/signed;
  boundary="nextPart1781653.3Hb6ZSkffo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1781653.3Hb6ZSkffo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 28 February 2009 20:31:01 Greg Banks wrote:
> Andreas Gruenbacher wrote:
> > Jumping between different versions of the auto* tools would become quite
> > ugly,
>
> Absolutely, you want to avoid that.  But conversely you can't rely on
> everybody who ever needs to change configure.ac having exactly the same
> version of autoconf as the maintainer.

that isnt to say we should attempt to support every random version out ther=
e. =20
if people want to make with autotools, it's reasonable to require them to h=
ave=20
recent versions.
=2Dmike

--nextPart1781653.3Hb6ZSkffo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJqkAkAAoJEEFjO5/oN/WBT0AQAL8DWySdOmxByXqN6JMEhOtW
U9G1xhhO9jYxBMq76tdqnL4ZOE0p6BbcMUg8HEbe2qBZfIlp08z86X+uxkQfDupJ
do6JJfV+j+y7rqB1nRJEbzjnED3uILmZOmdkwfLCwy4Nn5inHHZQaIg4ywdacBeH
ICQsFxAX4NEQM/VTZisWQxqQ+EJRg7OrESUfrIENTAhVhajZSSYMzqiOOuN0VHP1
zPgwrZ1w5LxmkrZcf6PHIOWIfuuIZaGyvMY0UiPlAqT8gobg0NCHEiLZgVRDeIk+
77/bdLgp9T3fAegyoZ3kdvrPQDMEzkqMQydHtKITGcDmCreT2d3zRGslpIfjayqf
X7rt9ssiXv84YoD9jSn3QPk5UC+5IbSYxs6TExzp8oZzx2DVPiQFtqxZ30TB5HjX
jEXdgKpq7xRjozsXlFEkys28bkyGz6Sd0S2hL7ks1zdunFkjecezhowpyMYpDaSl
T/vykLJFBJHMaGLGkuCi82xhL6KcGU6Pc3C4bqmoFgKVZL/BpCver7ajeM7qwu2g
4W/KGAG1JWDANxyVdG8fXBA4EBuzlsXOEJuQTg62azufj+TnOSDrU6aVdGF66jUf
3A0ysbJv7zy4rZbfNDUml9PD/u3jmF2WCKPLBTctN4mq4cOWu4Bj3owHd14hIQoC
7ljnldUhcSvfDUb2LOVW
=fX6K
-----END PGP SIGNATURE-----

--nextPart1781653.3Hb6ZSkffo--


--===============3645944816973395896==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3645944816973395896==--
