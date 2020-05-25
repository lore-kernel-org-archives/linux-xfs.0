Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F35CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 10:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6437420787
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 10:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389635AbgEYKBV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 May 2020 06:01:21 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:40254 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389633AbgEYKBU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 May 2020 06:01:20 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 05CFB5474C0;
        Mon, 25 May 2020 06:01:20 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 6935060AFD3;
        Mon, 25 May 2020 06:01:19 -0400 (EDT)
Date:   Mon, 25 May 2020 12:01:16 +0200
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
Message-ID: <20200525120116.077cce64@harpe.intellique.com>
In-Reply-To: <20200525032354.GV2040@dread.disaster.area>
References: <20200513023618.GA2040@dread.disaster.area>
        <20200519062338.GH17627@magnolia>
        <20200520011430.GS2040@dread.disaster.area>
        <20200520151510.11837539@harpe.intellique.com>
        <20200525032354.GV2040@dread.disaster.area>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_a8Z2caZmDUTq844ruajtGv"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--Sig_/_a8Z2caZmDUTq844ruajtGv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 25 May 2020 13:23:54 +1000
Dave Chinner <david@fromorbit.com> =C3=A9crivait:

> Not enough people think long term when it comes to computers - it
> should be more obvious now why I brought this up for discussion...

I'm thinking long term: I also run an Indy and an Octane and don't
plan to retire them any time soon :)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/_a8Z2caZmDUTq844ruajtGv
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl7Ll3AACgkQX3jQXNUicVamvQCgz31thpi/5vNiYG5mWvBRUCmN
+9AAnRhxrGUmzS9qYyM2ntNCSc7GyKV6
=on2i
-----END PGP SIGNATURE-----

--Sig_/_a8Z2caZmDUTq844ruajtGv--
