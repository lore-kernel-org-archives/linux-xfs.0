Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SMjQFV157877 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 16:45:26 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FEF6C6513
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 14:44:44 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id ompPuHbbd5KkpoiY for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 14:44:44 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: invalidated gpg signatures (was: Re: xfs open questions)
Date: Wed, 28 Jan 2009 23:44:13 +0100
References: <200901270928.29215@zmi.at>
	<200901282122.05588.Martin@lichtvoll.de>
	<20090128203703.GB3958@teal.hq.k1024.org>
	(sfid-20090128_220347_752737_13DDE9F8)
In-Reply-To: <20090128203703.GB3958@teal.hq.k1024.org>
MIME-Version: 1.0
Message-Id: <200901282344.32351.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5533992459587848669=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Iustin Pop <iusty@k1024.org>
Cc: xfs@oss.sgi.com

--===============5533992459587848669==
Content-Type: multipart/signed;
  boundary="nextPart2191547.HZm374fvPe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2191547.HZm374fvPe
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 28 Januar 2009 schrieb Iustin Pop:
> On Wed, Jan 28, 2009 at 09:22:00PM +0100, Martin Steigerwald wrote:
> > Am Mittwoch 28 Januar 2009 schrieb Russell Cattelan:
> > > Russell Cattelan wrote:
> > > > Michael Monnerie wrote:
> > > >> On Mittwoch 28 Januar 2009 Russell Cattelan wrote:
> > > >>> The sig is there, are you saying it's broken somehow?
> > > >>> It might have something to do with the html stripper.
> > > >>
> > > >> Yes, I use kmail (from KDE) which automatically displays mails
> > > >> with gpg- sigs in different colours to easily see if it's
> > > >> correct/trusted/wrong. And on this list, my messages all come
> > > >> with "Invalid Sig".
> > > >
> > > > Well I ran a test email through the test list on oss and it seems
> > > > to work fine.
> > > >
> > > > Let try it here then, I'm going to sign this and see if it come
> > > > back to me with a valid sig.
> > >
> > > Grr try #2
> >
> > Shown as invalid here - as the signature of Michael. I mentioned this
> > a few times already to.
> >
> > Signing this as well, but I expect it will come out as invalid too.
>
> For what is worth, gpg tells me on your email:
>
> gpg: Signature made Wed 28 Jan 2009 09:22:00 PM CET using DSA key ID
> A59984C7 gpg: Good signature from "Martin Steigerwald
> <Martin@Lichtvoll.de>" gpg:                 aka "Martin Steigerwald
> <Martin.Steigerwald@Web.de>" gpg:                 aka "Martin
> Steigerwald (Helios) <Martin@Lichtvoll.de>" gpg:                 aka
> "Martin Steigerwald <Martin.Steigerwald@Googlemail.com>"
>
> So maybe it's not the mailling list itself, but something else?

Strange. A bug in KMail with decoding GPG signaturesin *some* mails?=20
However I did find this only on the XFS mailing list so far. If I find=20
time I will take a closer look tomorrow.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2191547.HZm374fvPe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmA370ACgkQmRvqrKWZhMfLKgCgoulCy1lLcjYuYdKUL0Zob1se
lW8AoKedJjwmLAerlTnrdmTWI2W2yAlP
=J/Jp
-----END PGP SIGNATURE-----

--nextPart2191547.HZm374fvPe--


--===============5533992459587848669==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5533992459587848669==--
