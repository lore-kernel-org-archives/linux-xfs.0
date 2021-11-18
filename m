Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1462C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 05:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B906261221
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Nov 2021 05:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbhKRF1K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Nov 2021 00:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242408AbhKRF1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Nov 2021 00:27:07 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030B4C061764
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 21:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=2avjSYfHqTkV1GuGgkXinlVhPWuSjTNzekpIgEBqcmg=; b=Y/Xgiac9ypBF3LjhRbcCtyjI9X
        moHES9l4HLFUJMub0kb7p8JBcPommalcXLOx+w3uiFVpHYwFDY4f2d9nBLKhM+xJXI09g/odD35rq
        RxSLWvnH4JrT28xL6TpKdB47mXoyrTLary2bweOu7ycmcLHFGU/wsBZdVep8IpkDx2z5j7lAFWDoH
        4ZltHdTJHUOwDzmCz0L6w1sL8XIRvEHyPo8Av6Z/5k4/cdizQ4LX3KNajtaC/jDv6CXeSs7ohRvnp
        pYBaD+00MoJy4TdxseKsn4ljjYVTck0YvPvlLNRmFgWVTfIDcIr/W9T+yh6GcKfzK2XWFuDHu0jk0
        C24htFsg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mnZu0-0002gi-Sa; Thu, 18 Nov 2021 05:24:04 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Helmut Grohne <helmut@subdivi.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: xfsprogs FTCBFS: [TEST] CRC32 fails to compile
Message-ID: <handler.s.B.16372129108764.transcript@bugs.debian.org>
References: <YZPJDbOH7tDyK5sb@alf.mars> <YZPJDbOH7tDyK5sb@alf.mars>
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Thu, 18 Nov 2021 05:24:04 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing control commands:

> block -1 by 999743
Bug #999879 [src:xfsprogs] xfsprogs FTCBFS: [TEST] CRC32 fails to compile
999879 was not blocked by any bugs.
999879 was not blocking any bugs.
Added blocking bug(s) of 999879: 999743

--=20
999879: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D999879
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
