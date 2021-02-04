Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A88C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 20:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A65264DDD
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 20:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhBDUjz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 15:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBDUjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 15:39:51 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780A8C061786
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 12:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=l2T+9XzF3aYvzGQp/STkmRb9zPJgc4bJBkfJSGvgaUM=; b=UkvbybaLNEwH8vQc4NoPVTqWUh
        m8vuQg0JtDSaYdmvGNu7b8giUJ+3h5bdeYtNUnCzxLoCDsZKRl5NmxFx007ON9QKnbzpRESeaDwqY
        xSSvxa+PIjx7JxPjWqVjbGsNKYw/UwfsKAqKCc/Q6pADhdP4G7jAMrZ1olYQldVnrzrz8Br93Ahbq
        CixCgNeFiNi3gx9atSo+hhTN+cRGgJ16V63lyc9PQTuF5OV0jBv6eR+mmSxALqI0Esv6rLbNDI1Ui
        Q3tfhpGZbv2CVVd6ytKkWWHzzg9CCucw9g/iIQy/kSTyZfnFlx90mmn9lSQWJLpwRmxrTID83ffpS
        Uwhxg4zQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7lP7-0005kA-Un; Thu, 04 Feb 2021 20:39:05 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: Re: xfsprogs: {mkfs.xfs] Please provide GNU --long options
Message-ID: <handler.s.B539723.161247087920221.transcript@bugs.debian.org>
References: <730f3efc-253c-4eea-f4bc-9979e9e6b3c3@fishpost.de>
 <20090803093257.29785.85748.reportbug@jondo.cante.net>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Thu, 04 Feb 2021 20:39:05 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing control commands:

> notfound -1 xfsprogs/3.0.2
Bug #539723 [xfsprogs] xfsprogs: {mkfs.xfs] Please provide GNU --long optio=
ns
No longer marked as found in versions xfsprogs/3.0.2.

--=20
539723: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D539723
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
