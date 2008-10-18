Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 13:14:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9IKErqJ004377
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 13:14:53 -0700
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3F5EAC4213
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 13:16:36 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188]) by cuda.sgi.com with ESMTP id yggZl6PlWBFALXPU for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 13:16:36 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id h3so519746nfh.42
        for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 13:16:35 -0700 (PDT)
Date: Sat, 18 Oct 2008 23:17:50 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081018201747.GB2083@localhost.localdomain>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <20081017094615.GT4504@soziologie.ch> <20081018194851.GA2083@localhost.localdomain> <20081018200939.GA3779@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <20081018200939.GA3779@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 18, 2008 at 04:09:39PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 18, 2008 at 10:48:53PM +0300, Kirill A. Shutemov wrote:
> > Our team have experience with XFS on ARM OABI on NAS. It worked fine on
> > 2.6.12, but got broken on 2.6.17.
>=20
> So any chance to bisect it down to at least a kernel release where it
> stopped working?

I'll try to do it.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj6RGsACgkQbWYnhzC5v6oP+gCdG37HnYwqMJVvr6tMSa+N02WD
EW8An2Ep/FRKxSb9D57ZjV+wUvf81gyI
=iSPt
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
