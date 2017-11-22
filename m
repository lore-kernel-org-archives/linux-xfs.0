Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41194 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdKVQT3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 11:19:29 -0500
Date: Wed, 22 Nov 2017 17:19:28 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171122161927.GC12684@amd>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <20171107191526.x3rzfcnnlmaz264d@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-11-07 14:15:26, Theodore Ts'o wrote:
> On Tue, Nov 07, 2017 at 06:46:58PM +0000, Alan Cox wrote:
> > > Given that it had no license text on it at all, it "defaults" to GPLv=
2,
> > > so the GPLv2 SPDX identifier was added to it.
> > >=20
> > > No copyright was changed, nothing at all happened except we explicitly
> > > list the license of the file, instead of it being "implicit" before.
> >=20
> > Well if Christoph owns the copyright (if there is one) and he has stated
> > he believes it is too trivial to copyright then it needs an SPDX tag th=
at
> > indicates the rightsholder has stated it's too trivial to copyright and
> > (by estoppel) revoked any right they might have to pursue a claim.
>=20
> If Cristoph has revoked any right to pursue a claim, then he's also
> legally given up the right to complain if, say, Bradley Kuhn starting
> distributing a version with a GPLv3 permission statement --- or if Greg
> K-H adds a GPLv2 SPDX identifier.  :-)

Yes, maybe Greg can legaly do that. That does not make it good
idea... and we have higher standards than "not illegal in most
countries" :-).

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloVo48ACgkQMOfwapXb+vJNAQCgp/LaiGz11X2h2wCTrcDZ3Tyq
q1gAn11od+TZG+1G7DY3LkOKlwAZfoCB
=9XM9
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
