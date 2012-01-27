Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0R05mu7054482 for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 18:05:48 -0600
Date: Fri, 27 Jan 2012 11:05:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: XFS for-next branch
Message-Id: <20120127110533.10304c6a33b83ac8e778915c@canb.auug.org.au>
In-Reply-To: <20120125171244.GX8262@sgi.com>
References: <20120125171244.GX8262@sgi.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2875740798481381043=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs-masters@oss.sgi.com, linux-next@vger.kernel.org, xfs@oss.sgi.com

--===============2875740798481381043==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Jan_2012_11_05_33_+1100_i49ME4GPcmRrH3K."

--Signature=_Fri__27_Jan_2012_11_05_33_+1100_i49ME4GPcmRrH3K.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Wed, 25 Jan 2012 11:12:44 -0600 Ben Myers <bpm@sgi.com> wrote:
>
> Could you pull XFS updates from
>=20
> git://oss.sgi.com/xfs/xfs.git for-next
>=20
> instead of from the oss/master branch for 3.3?

OK, currently I fetch the "master" branch of that tree.  And you want em
to switch to the "for-next" branch, right?  (Those two branches currently
point to the same commit, so I have not changed yet.)

Did you mean "3.3", or "3.4"?

Currently the contacts for that tree are: David Chinner
<david@fromorbit.com>, xfs-masters@oss.sgi.com.  Should I change that?
i.e. who has control over the tree and can fix problems if I report them?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Jan_2012_11_05_33_+1100_i49ME4GPcmRrH3K.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPIepNAAoJEECxmPOUX5FEmLcQAKg1mkTWQV8Qs0EkvU7ByKYu
sAr1GA+ctvmkTedAFJGxQuuC62wAkD5HcWQ8+F3K2sSSBnuaMZJsUzMKIXE3ezYs
Jttv1oHa/ZM4UjTjWsptqCn3q0Kg5m4R3cT+qvNFr0RSfC7Rthy/pRs4abDIRC9L
Xa5TGRPSiNlLIEJpbvIQAUufPr5ps3FpvERlTOOKMvq2aaC0U1wE8y56463wdw5e
FHEZeuqusnLMf8YdfEuCYbX3sLKyEL94cQr7hoas3vbNtgghE81A2KzQpAXSm6ZZ
AbfFRGZVkKXVvX2hgRsdsL56lNj6TGIP8JPbsdxLyPUfZjldwXSEb7pwmudVkdIx
qiRiBod1z01MZfTbqoFkMm9YcIW2KVtBIfAdYerWkyWa6b8TkuuOaF5MtWe2nMNh
mwwdRKIrXEV1rxzbfcYY3hrl7ZBOGUngUf79WB+Tsv43CiejdI2HhWHssrPn+uPL
+rxINLHxg+rFtFJT7HEvMyMeKErRfyKqc32NAYmyF0+79Xrm0IKgZ1zT9xMIfmwS
WOnG9iPQUEyTBJAnISp/7sVzaM78jbYfMe6Kv59q/oE5yZBsisMVQhrS85J5nAQw
XchzEY9Br+Pc6tA3sCMEv+YbQRSmmdZ/do/wO6OmI5TUqBahIiiIAnun1QtAq2YL
3VpMWsJv11Zq0jmjyecv
=2f99
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jan_2012_11_05_33_+1100_i49ME4GPcmRrH3K.--


--===============2875740798481381043==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2875740798481381043==--
