Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EED1B7F55
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 20:38:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CCEC78F8054
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 18:38:21 -0800 (PST)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id FJbGhGcozgGWWnCw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 18:38:19 -0800 (PST)
Date: Fri, 13 Feb 2015 13:38:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150213133811.5c3b9f49@canb.auug.org.au>
In-Reply-To: <20150213015422.GE12722@dastard>
References: <20150205004758.GO4251@dastard> <20150205070858.GA593@lst.de>
	<20150205135756.GA6386@lst.de> <20150206222047.GM12722@dastard>
	<20150206224258.GJ29783@fieldses.org>
	<20150208133435.GA27081@lst.de>
	<20150208090942.51e99687@tlielax.poochiereds.net>
	<20150209201154.GA27746@fieldses.org>
	<20150210000423.GY12722@dastard>
	<20150213011130.GA6808@fieldses.org>
	<20150213015422.GE12722@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5229908413125308783=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Layton <jeff.layton@primarydata.com>

--===============5229908413125308783==
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/72iLWnDTYf9Pc=xJPr1Q12+"; protocol="application/pgp-signature"

--Sig_/72iLWnDTYf9Pc=xJPr1Q12+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 13 Feb 2015 12:54:22 +1100 Dave Chinner <david@fromorbit.com> wrote:
>
> Thanks Bruce. I might have to build a merged tree because one of the
> changes from the review modified a header file introduced in the NFS
> tree.
>=20
> I'll see how it goes, and see if I can avoid doing something that
> will make Linus yell at me :P

If its a syntactic conflict with an obvious resolution, just leave it
(or maybe mention it in the pull request).  It gives him something to
do so he feels useful. :-)

/me notes that I did not see a conflict while merging the xfs tree in
linux-next today ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/72iLWnDTYf9Pc=xJPr1Q12+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJU3WOYAAoJEMDTa8Ir7ZwVNrMP/1MGyDeHamIa2ByYrBlsbCoS
bq9BV7bEw5lXMK4pklOHwDtJmsPs/ozuCZ4Yc65UkEbE3f228ZyMXNVODcrJBtTc
66xfJpFhx9P7Stk/ViDLv3GPPwS3iW93Ru/62dNhy81NGRXznY1YQ8quzX8H/nmD
JxACRPsDtLnUCFIskpxc9WYBAgP9hbU2UfBD+ryfOf11GNcW8FC5IFfxaWK/D/or
6nyRCJ0KeVmEy/zIQ6TT32I/RIe78VPKJ3fuY+wAOiWzv4fUI9uP7W0i1rfZYb6Z
+aQ+E4GTp5WUmI2vGf7hnbZTdEmaXzP+PFnz2bMSCUr/FLiOiJS1kiDqVZQaZjgQ
ItHInE1emxenhVaHsqSCQ6LEl0auAgqKfw27A3Po4xYX0ZTIUQGaA1cZtwxv79bz
CNVK2Puy3GIRiu4G2HQqjkvFu3FXdwSUEnm6y+6xpDEi7oUaJJJy9szLP9rTeBYq
0odtBEn2m88EUME/hJskO3OwIrMPPCyP0/cOfaJIoEWvHMMxttmqbGnAF7Cq/mrr
1X8xdh+3pwfMyqolqiU3ZiU4hM12dmj4jFoLdIfSCPSZxup795FEUcbb1KTam+/P
irnAfzhr0+E5caWYfurlB8RHxF6+2w3CCwnB15nmW6GHb6m/Y3U4eIRV72GgOzg4
ZMI7g9jls6pXGv7rvYge
=uaiD
-----END PGP SIGNATURE-----

--Sig_/72iLWnDTYf9Pc=xJPr1Q12+--


--===============5229908413125308783==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5229908413125308783==--
