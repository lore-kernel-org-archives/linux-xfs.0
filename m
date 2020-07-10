Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B72C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 15:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5279C20720
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 15:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="tyaraTMw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGJPz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 11:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJPz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 11:55:57 -0400
X-Greylist: delayed 646 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Jul 2020 08:55:57 PDT
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1A0C08C5CE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 08:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=Emk5ZDHfk82KXP0AXFojJwLVdBN03ZbyWC5lSJeWUoE=; b=tyaraTMwHswAeyG0ZLf7wWyIew
        u7qdvAo/bRhgEd0Uv8jMXcpyWYCmh+PvsPF4Cc92okij817N8gSgQH2J85O8pLrXOO62uZA2JWcpB
        21IhjfqbEL7h/qnvaxn6pkmGgqMXI6nTP0970quNfwhT7QC3U2hJP/eBpW6yBDR1flz2ozpuqe3KY
        y/9aS6ymRtUgU4KlLTuQqzfutjii1YfyysV2yy9rSqw9St0ibcGvyPUr9GT7I+6F0Ilfa/4CVQchs
        CxZRmcMIBb/5tErmOvKLLHroXlKZn8tGZwDs7FQFQPQA2uZveQGejnMWo1EYdRrH+jhbAyXh7lWWV
        Qd6ozA1g==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1jtvD4-0007g1-5i; Fri, 10 Jul 2020 15:45:10 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Anibal Monsalve Salazar <anibal@debian.org>
Subject: Bug#925111: marked as done (Updating the xfsprogs Uploaders list)
Message-ID: <handler.925111.D925111.159439581328225.ackdone@bugs.debian.org>
References: <20200710154331.GA15080@debian.org>
 <20190319114524.b4aekf3ulanskbis@pimeys.fr>
X-Debian-PR-Message: closed 925111
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
Reply-To: 925111@bugs.debian.org
Date:   Fri, 10 Jul 2020 15:45:10 +0000
Content-Type: multipart/mixed; boundary="----------=_1594395910-29506-0"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1594395910-29506-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Fri, 10 Jul 2020 15:43:31 +0000
with message-id <20200710154331.GA15080@debian.org>
and subject line done
has caused the Debian Bug report #925111,
regarding Updating the xfsprogs Uploaders list
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
925111: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D925111
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1594395910-29506-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 19 Mar 2019 21:13:12 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	FROM_EXCESS_BASE64,PGPSIGNATURE,TXREP,X_DEBBUGS_CC autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 8; hammy, 142; neutral, 45; spammy, 0.
	spammytokens: hammytokens:0.000-+--H*ct:application,
	0.000-+--H*ct:protocol, 0.000-+--H*ct:micalg, 0.000-+--H*ct:signed,
	0.000-+--H*ct:pgp-signature
Return-path: <peb@debian.org>
Received: from pile.pimeys.fr ([62.210.112.15] helo=mx.pimeys.fr)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <peb@debian.org>)
	id 1h6M2p-0004R1-HW
	for submit@bugs.debian.org; Tue, 19 Mar 2019 21:13:12 +0000
Received: from pimeys.fr (pile.pimeys.fr [62.210.112.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx.pimeys.fr (Postfix) with ESMTPSA id 552502407FC;
	Tue, 19 Mar 2019 12:45:26 +0100 (CET)
Date: Tue, 19 Mar 2019 12:45:25 +0100
From: Pierre-Elliott =?utf-8?B?QsOpY3Vl?= <peb@debian.org>
To: submit@bugs.debian.org
Subject: Updating the xfsprogs Uploaders list
Message-ID: <20190319114524.b4aekf3ulanskbis@pimeys.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kwrcqlbcc77v2xkq"
Content-Disposition: inline
X-Debbugs-Cc: anibal
X-MIA-Summary: -; asking for removal from xfsprogs Uploaders
User-Agent: NeoMutt/20180716
Delivered-To: submit@bugs.debian.org


--kwrcqlbcc77v2xkq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Source: xfsprogs
Version: 4.20.0-1
Severity: minor
User: mia@qa.debian.org
Usertags: mia-teammaint

anibal has not been working on
the xfsprogs package for quite some time.

We are tracking their status in the MIA team and would like to ask you
to remove them from the Uploaders list of the package so we can close
that part of the file.

(If the person is listed as Maintainer, what we are asking is to please
step in as a new maintainer.)

Thanks.

--=20
Pierre-Elliott B=E9cue
GPG: 9AE0 4D98 6400 E3B6 7528  F493 0D44 2664 1949 74E2
It's far easier to fight for one's principles than to live up to them.

--kwrcqlbcc77v2xkq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEESYqTBWsFJgT6y8ijKb+g0HkpCsoFAlyQ1lMACgkQKb+g0Hkp
Csq+ZxAAihynw8Id/kMas1+k2WCoS2siJJyTGerL/91rp4QNDZwEM3vAw3wndaSZ
rNWXwQBji8rRI2UpypmAlLDR1TLSuT0r9DOs2IoOhIHYFSvY8Ot8j0gt4wP/IZRi
g/npnTvFzhOb943UP347SH01r0juRrB0OOsL0QHdZv1SZx9fzOmwppEeaj8DK4OM
feioLU+CXA7Y7l866n32FlvZelCaakL7PMcxPfZlZzySaOf6x+kbfaXxS+2c3TKv
mVM6G13V2yKatYQ/pbkUBRAOVnpk6iQA7cbPbTpeHHyJrUntf6LWylTJMq04yj/i
ZFs1WyXJ14Y+hRQ3M6ruZ+Cgt3vfyRLBcvH5jaExxaYd9PPZTJfi+OsRYs5ERaAu
zf+jYjj38PfmXQFnt7ME7cpEl072NawjGFuJlgTafN6Bfnu6KThdNsKfdrtsxnva
RUojWiK8FLpWNPMCJSevJau7YpAnbG8f+nSVc1RliBDoN14rzrhjiZKcrRR+IiQ/
LegVM9t0keaqGCZQXCHOXr9cHWJ2+jbswF6QDan/HHEzwiyzTUrawugX9ztKfqio
lDYHSD6WSiftaxMEIHHJD0dJ1FnNGuhZKr5pU9h935zIsyglqS+SeSKM1NO0MpLt
pZJz2TtvOvt5z6ysKebzNqhPl6f2a8A9fkZlYba9WBNBOiXl9EE=
=h32r
-----END PGP SIGNATURE-----

--kwrcqlbcc77v2xkq--

------------=_1594395910-29506-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 925111-done) by bugs.debian.org; 10 Jul 2020 15:43:33 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=4.0 tests=ALL_TRUSTED,BAYES_00,CLOSE,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	FROMDEVELOPER,ONEWORD,ONEWORDALL,ONEWORDBODY,SPF_HELO_NONE,SPF_NONE,
	TXREP autolearn=no autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 14; hammy, 84; neutral, 13; spammy, 0.
	spammytokens: hammytokens:0.000-+--H*UA:1.10.1, 0.000-+--H*u:1.10.1,
	0.000-+--H*UA:2018-07-13, 0.000-+--H*u:2018-07-13,
	0.000-+--Hx-spam-relays-external:36ff
Return-path: <anibal@master.debian.org>
Received: from master.debian.org ([2001:41b8:202:deb:216:36ff:fe40:4001]:44138)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=master.debian.org,EMAIL=hostmaster@master.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <anibal@master.debian.org>)
	id 1jtvBV-0007Ks-La; Fri, 10 Jul 2020 15:43:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	 s=smtpauto.master; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:
	Date:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=EuXLHWUh1qnwNpl4zKbsk8UlgolmCL8SiCdkriGgxuQ=; b=XW
	H7Gf1EEn3f/35TPSV7oUxAl3RC7xKqwhDDBRMf7y5zkaKYEbksFG3ypsqJXNPl3tjyRPwKUcCKgVh
	XhBYez3CvVFbWylzuNvqUzzdGSVXkFvb1xxJ3dWaJ96r5SVCS1K4JD2mUbmpE+6c/JyDb4qb6aSuf
	nWBBVu6CRBWJMqF6JZRct1yd7OyLNSoh3ZUVTJsqbUvzoePaGz4RZgBMkaCPusz2frRPkTjuWLUqZ
	RGiYnVTIlyhPbfhGYtmH/ut5NgzRttfb43z+Mr8MyyUoKCdVGDyCnTOpr2tlGEPQSSB1G9nnsSRRv
	TW0m0zA/Tvyj8EsYhoEEv0sax66BdmHg==;
Received: from anibal by master.debian.org with local (Exim 4.92)
	(envelope-from <anibal@master.debian.org>)
	id 1jtvBT-0004FN-PZ; Fri, 10 Jul 2020 15:43:31 +0000
Date: Fri, 10 Jul 2020 15:43:31 +0000
From: Anibal Monsalve Salazar <anibal@debian.org>
To: 925111-done@bugs.debian.org, 925086-done@bugs.debian.org,
	925088-done@bugs.debian.org
Subject: done
Message-ID: <20200710154331.GA15080@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CrossAssassin-Score: 3

done
------------=_1594395910-29506-0--
