Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EE2eML129072 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:02:40 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94ACA70491
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:03:27 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Geohweg19icLgycF for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 07:03:27 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS Filesystem not mounting
Date: Tue, 14 Sep 2010 16:03:24 +0200
References: <29704010.post@talk.nabble.com>
	<20100914082504.4109712d@galadriel.home>
	<29708085.post@talk.nabble.com>
In-Reply-To: <29708085.post@talk.nabble.com>
MIME-Version: 1.0
Message-Id: <201009141603.24754@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4469371085696209276=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: pbrunnen <PBrunnen@bccnetworks.net>

--===============4469371085696209276==
Content-Type: multipart/signed;
  boundary="nextPart8048595.qMENPFqbRH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart8048595.qMENPFqbRH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 14. September 2010 pbrunnen wrote:
> Hello all...
>    First and foremost I want to say Thank You to everyone for the
>  sounding board.  Yesterday was a bit panicky for me.  ;-)
>=20
>    Time was not my friend and I ended up having to try the route that
> Emmanuel suggested by rebuilding the log with "xfs_repair -L"... =20
>  Tried to avoid it until the end.

And did it work out finally? Was a destroyed log the problem?

>   Yes, its based on 10.2...  The kernel is one of the only things not
> updated.  I really don't like the newer builds of SuSE as much and
>  have been reluctant to upgrade.  I am considering to build a newer
>  kernel or switch to debian.

I'm currently on 11.2, and must say it's the best I ever worked with.=20
Especially upgrading is so fast, smooth and easy now (in-place upgrade)=20
that it really makes fun. Didn't have time to upgrade to 11.3, I just=20
did a fresh install of it once and it looked even better (desktop=20
version on a notebook).

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart8048595.qMENPFqbRH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyPgKwACgkQzhSR9xwSCbRRZQCgzpISSuM0+rGXhaEIX0t6Yco6
J6EAn0gHqZcBsweE8Ix3gvsuDmjnp+zy
=m1MM
-----END PGP SIGNATURE-----

--nextPart8048595.qMENPFqbRH--


--===============4469371085696209276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4469371085696209276==--
