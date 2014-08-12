Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7B5C7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 08:56:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B2CB78F8037
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 06:56:25 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id padfAzpmnJ68EVJZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 06:56:23 -0700 (PDT)
Date: Tue, 12 Aug 2014 23:56:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] xfs: updates for 3.17-rc1
Message-ID: <20140812235612.684a9af7@canb.auug.org.au>
In-Reply-To: <20140812125313.GX20518@dastard>
References: <20140812125313.GX20518@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8868843927533126848=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

--===============8868843927533126848==
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FbP4CYOTAJSl_7QI41nE3ce"; protocol="application/pgp-signature"

--Sig_/FbP4CYOTAJSl_7QI41nE3ce
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 12 Aug 2014 22:53:13 +1000 Dave Chinner <david@fromorbit.com> wrote:
>
> FYI, this will be the last pull request I will send you from a tree
> on oss.sgi.com. I'm moving everything XFS related over to kernel.org
> so future pull requests should come from there.

Please let me know when you have the new tree set up so I can change
where I fetch from.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/FbP4CYOTAJSl_7QI41nE3ce
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT6h0DAAoJEMDTa8Ir7ZwVa0wP/j0ONjUshXWfwHbGiWLU/K45
8AqHE2OHvFL1GIcnOE+heXmYMn0HVzkfFPzp0HFR98JubgXI4kFPxTBjb7bSh1KQ
t0NstYhroALRf4XLS82EuIgfauy0B7BxTfEkD1j9Ai9qQI2jQ0e4BkWX0MayVQwD
CRnkmzjMFWGu/3ARGckAX7QPWeQ63vQAgdNNRh9ryBLQutHVeTBjr8ls+WcOZwCJ
+hCI4lZE4sw04ThZWOHxs4p84+OFLJfYXxLiLMJoGfHlvVlNBDoBXDr7pGkayvUF
ky5FIj1akiuOOXhuYfRSJk1iuOUtGAgn0nIqMqZvb/ixhWJEy2cXF7GP3pC9cb/9
qNeT0sxqGzR3mFfnPrRApFIjiU+yeFV50OXj3UMD6yChWDmGLgaIf0dIMt3uJfkR
WvBF2gGs8DypYUxHZSdUAUfwy3HvgEYtGjJcOxgZKaxtAtvPTkUZ0CLiUvAW/jmU
eHqlKURZOmuJyDdYpQNulvJZv0DhHBkF/Bw/8eLV/K81kPpiuq3lrScxsUKk72pv
T9Rzgwent2s3P8jcYHIxTpiK0QxONYnEX+wTHFUffXXI5u+V53Mt8ckSsAbH46zx
Trfpbppj5+/pUiE8p6zuRuLmoObEVbHlIV6OTkz8Ezb9Qe24EJS2osfYcVkkPIiq
ogUHFE95BdGRNNo1XC6O
=Rp08
-----END PGP SIGNATURE-----

--Sig_/FbP4CYOTAJSl_7QI41nE3ce--


--===============8868843927533126848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8868843927533126848==--
