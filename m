Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B6387F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 17:59:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93078AC002
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 15:59:21 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id xJnDXBTjJX7ghEFN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 15:59:19 -0700 (PDT)
Date: Wed, 13 Aug 2014 08:59:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] xfs: updates for 3.17-rc1
Message-ID: <20140813085911.53e5fbd5@canb.auug.org.au>
In-Reply-To: <20140812215344.GY20518@dastard>
References: <20140812125313.GX20518@dastard>
	<20140812235612.684a9af7@canb.auug.org.au>
	<20140812215344.GY20518@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0243168027345188497=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

--===============0243168027345188497==
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1YyK36QbUd5rdgnKeGq9nH6"; protocol="application/pgp-signature"

--Sig_/1YyK36QbUd5rdgnKeGq9nH6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 13 Aug 2014 07:53:44 +1000 Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Aug 12, 2014 at 11:56:12PM +1000, Stephen Rothwell wrote:
> >=20
> > On Tue, 12 Aug 2014 22:53:13 +1000 Dave Chinner <david@fromorbit.com> w=
rote:
> > >
> > > FYI, this will be the last pull request I will send you from a tree
> > > on oss.sgi.com. I'm moving everything XFS related over to kernel.org
> > > so future pull requests should come from there.
> >=20
> > Please let me know when you have the new tree set up so I can change
> > where I fetch from.
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git for-next

OK, I have switched starting today.

> It should be identical to the xfs tree you are pulling from
> oss.sgi.com.

Yep, it is.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/1YyK36QbUd5rdgnKeGq9nH6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT6pxEAAoJEMDTa8Ir7ZwVAgYQAIc2j31HcOScP1IyQxqPxGTc
ZhM/fjZplQVmi6aWu1QTNhVSsaxp3pAXMfFp2NgY8YqRBV4TqGeeAmhpajScoBA/
eB39G8lBliESfghGuz3hHTFFVJ0qgZPTJi1l/zf+BCwTZ/P8klKzoRKWPJQC+Sag
drx6s4/C/UinjLg9QkD3bPE+KRWhh+GFaoaIOl82xYQlDsHNCkBl5ofFp8UDJecg
Hu8zyVKVrFqYpT7tvVCf3YB5cFxu2rCeH3FjF+cX/K1eu1pV8iqq+HHmZks2Jni5
4hTMCluWrO1TVL0kfwBJRveoSUHK0gt0ZIq+RVH/TtH9fzsl8VW9wY29sr8SdDga
8Hs2wcLL5WFnomeInxL0Ouzm7FnMkVZi088K0tVnQGpIaLG0jBoAo1j1j3NMuqro
1iP+ehG8WrT/kGYIJhLwD+9DH/gzIDlrS8Q6DKiPLQL2w0pWhxFyhv5TqN+0QmCG
yfkTe9PnmPzo+CTDiuYYR8lM/WtUw4UeMf4rxooUs5ygPApl7epl5UeuHwt8Mnjd
PDCEZSHWYYfGFfyXH941bZOw3inlHJpNTptpjfZpZz8gnwaJPDx0GLa7eFLGXtOM
mHlkXZosCFlBvzC0ialekR5nQUh9xMN6ScFUrzhHAMyreKCEhfdbXYy+MmGtHS3c
WO5McYkEr2aw9c3K04yB
=uxmt
-----END PGP SIGNATURE-----

--Sig_/1YyK36QbUd5rdgnKeGq9nH6--


--===============0243168027345188497==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0243168027345188497==--
