Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42833 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbcLUHR0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2016 02:17:26 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uBL7HPT1009073
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2016 07:17:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id uBL7HP1v019156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2016 07:17:25 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id uBL7HPaV019444
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2016 07:17:25 GMT
Date: Tue, 20 Dec 2016 23:17:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-documentation: master branch updated to fc7cfa0
Message-ID: <20161221071724.GB23294@birch.djwong.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

There's not a lot in this update, other than some minor typos
and other fixes I've had queueing for a while.

The new head of the master branch is commit:

fc7cfa0	docs: enumerate possible directory ftype values

New Commits:

Darrick J. Wong (3):
      docs: fix a typo in the AGF section of the disk format doc
      docs: update refcount btree to reflect new cow staging extent policy
      docs: enumerate possible directory ftype values

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJYWiyEAAoJEPh/dxk0SrTrUIsP/AkG9q1uwX/LTPcqsYIEx7X9
XXqUNkr8G0j1YI/AOHJcm4lJNVIqpjz32hAILRR5lvu9PAO02IxZNXri9HajbMbd
L0mLfsUHyJZF/FU9h+PyyeIGzFjDb4r3mPJI0qICg8nI1cmLLTBkPrg73HpHHMXc
FJ5ReBSA4uUaKOlovs2VmUi86bVv7k95LcyiU68wB0x6Co/8K6cM6s2fAV4VQX0q
yOjCacQqxRNQzPBOwFbfIY+36on3Y+uqeMRdXTQ0RuTDjNN5QEtbXzab/5WBVSVD
v9CRQZgZSKQuldkF2HJWcQQq3iwL+Mjq93tpc0l3RwKvc4AwhEsOHBoA1E+GZG45
ZqxB7UFNGVRf9X2+sMaskC99uqWZEftBQnxwIaEMT8i3sAST3aSxAUTIMlgaWRx4
iZtBgCyikKj2XKoNFdNpQj/Vp1UXmdagprJP/ABdnHFxZPUhHrJf+Vu6Avcn/Kst
WvhoBrgef3JS9Ov8U//3TmeyZTVQn4W4p1dSR0Cp4LcmxdS2qZ9mMHQsceEluA/S
85LyHZkl7kY5KPKYp1Ie4lpRptEY6uZ7Oj/O00iJNw1u7TVAKUrRF02QtmwdF5j4
z+lh1SBjtFXTLHkB3C7YjUm9ONaY/MNmlaw2I9J/WwdzJDnytJn7sBIGCctpyLSM
KA0CE9ngxt7aNB0/MzLp
=mx1D
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
