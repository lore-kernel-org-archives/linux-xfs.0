Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7E9nKGc142360 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 04:49:21 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E5E7CAC3D3
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 02:58:42 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id aTyvwzPqk2ukvqB6 for
	<xfs@oss.sgi.com>; Sat, 14 Aug 2010 02:58:42 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Message to Stan Hoeppner
Date: Sat, 14 Aug 2010 11:49:30 +0200
References: <201008131300.40536@zmi.at> <4C6627E4.3040000@hardwarefreak.com>
	(sfid-20100814_092332_879282_FAC1CB60)
In-Reply-To: <4C6627E4.3040000@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201008141149.37526.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4986860463752520733=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

--===============4986860463752520733==
Content-Type: multipart/signed;
  boundary="nextPart2665223.Uz4xhOOUxM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2665223.Uz4xhOOUxM
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Samstag 14 August 2010 schrieb Stan Hoeppner:
> Michael Monnerie put forth on 8/13/2010 6:00 AM:
> > Dear Stan,

Hi!

> > <stan@hardwarefreak.com>: host greer.hardwarefreak.com[65.41.216.221]
> > said: 550    5.7.1 <mailsrv1.zmi.at[212.69.164.54]>: Client host
> > rejected: We do not accept mail from .at domains (in reply to RCPT TO
> > command)
> >=20
> > I don't know what experiences you've had, but Austria is not that
> > bad. We have Mozart, Walzer, the Danube, and Vienna is worlds most
> > beautiful city to live in (search "vienna best city in the world" on
> > Google finds http://www.citymayors.com/features/quality_survey.html
> > and others).
> >=20
> > Maybe you could rethink that policy? Spam rate is quite low with .at
> > domains, compared to others.
>=20
> Fixed.  Sorry about that Michael.  I had an old pcre that checked the
> SMTP client rDNS host name against a bunch of ccTLDs I received spam
> from some time ago.  I forgot to disable it when I moved to a much
> more effective and a bit more sane anti-spam configuration.  I'm
> surprised someone such as yourself hadn't tripped this before now with
> all the lists I subscribe to.
>=20
> That said, I do still block some entire countries' IP space using
> ipdeny.com info, such as China, Russia, Korea, Malaysia, and a handful
> of others from which I'll likely never receive legit mail.  I might
> from Russia due to some of my list memberships.

Hmmm, I use policyd-weight to weight several blacklists instead of=20
blocking complete country IP spaces unconditionally and together with some=
=20
local spam filtering with CRM114 at home it keeps spam gets through rate=20
very comfortable low for more than a year already. I estimate I do not=20
have more than 20 spam mails marked as unsure in a whole week.The rate is=20
a bit higher at work, but still quite comfortable, where Zimbra does the=20
additional spam filtering I think with a learnable Spamassassin setup. But=
=20
most mail is blocked by policyd-weight at SMTP level anyway.

So I do not see any need to block complete IP spaces, but your mileage may=
=20
vary.=20

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2665223.Uz4xhOOUxM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxmZqoACgkQmRvqrKWZhMe36gCeKnCtnpjtz7MZW5+lUsviFMDn
SEQAn1x6SYb1zS8GE3/bUzU3I8kqKqNI
=Sk7A
-----END PGP SIGNATURE-----

--nextPart2665223.Uz4xhOOUxM--


--===============4986860463752520733==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4986860463752520733==--
