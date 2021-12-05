Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252EBC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Dec 2021 16:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhLEQYd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Dec 2021 11:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhLEQYd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Dec 2021 11:24:33 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23623C061714
        for <linux-xfs@vger.kernel.org>; Sun,  5 Dec 2021 08:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=NcjSb8d8a+uBJI9mFrVPv6Bc+282jm2fhEzXjf/SeXU=; b=jdHbGSVPJJSZaS0f6SR3uyuvQw
        vHLOr4qoMNNcfjAx/gW0sYsX/eMvnEkIBswX1qVySvWjPpUz7hKxClcrA1z+QemU1pzn+6uUb4Gpk
        cLq+Rkd/P1qiaPXAb9HSPdPd1CzYcxncZZchDc+9QIbtsO4HZRwZ6SO6H13RBZISn8DvOxuXemxSc
        nl8+acPwqQj35XSloHr9QfdQjFSqn79p3Om21PtdKwnnniZPi96XAnyEqK4QQ3xSe8OFGWNFDqM6f
        fR1O3JfObCAd+Q1Pp/aOybgExknvbZ8eCO0FKTcHzdmPDGAyvnyVcX7MVGBaXZrYSEQUiLF2d4JEk
        IP4YTasQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mtuG7-0004GM-Rx; Sun, 05 Dec 2021 16:21:03 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Giovanni Mascellani <gio@debian.org>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: retitle 1000974 to xfs/linux.h defines common word
 "fallthrough" breaking unrelated headers
Message-ID: <handler.s.C.163872096813500.transcript@bugs.debian.org>
References: <1638720446-357-bts-gio@debian.org>
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Sun, 05 Dec 2021 16:21:03 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> retitle 1000974 xfs/linux.h defines common word "fallthrough" breaking un=
related headers
Bug #1000974 [xfslibs-dev] xfs/linux.h defines common word "fallthrough" br=
eaking
Changed Bug title to 'xfs/linux.h defines common word "fallthrough" breakin=
g unrelated headers' from 'xfs/linux.h defines common word "fallthrough" br=
eaking'.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1000974: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1000974
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
