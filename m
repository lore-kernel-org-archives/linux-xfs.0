Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE02C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37DF61A3A
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhKSRh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbhKSRh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 12:37:58 -0500
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BFAC061574
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 09:34:56 -0800 (PST)
Received: from fasolo.debian.org ([138.16.160.17]:34530)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mo7mo-0005mm-OG; Fri, 19 Nov 2021 17:34:54 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
        (envelope-from <envelope@ftp-master.debian.org>)
        id 1mo7mn-0006Uh-JF; Fri, 19 Nov 2021 17:34:53 +0000
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
To:     <bage@linutronix.de>, Nathan Scott <nathans@debian.org>,
        XFS Development Team <linux-xfs@vger.kernel.org>
X-DAK:  dak process-upload
X-DAK-Rejection: automatic
X-Debian: DAK
X-Debian-Package: xfsprogs
Auto-Submitted: auto-generated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: xfsprogs_5.14.0-1_source.changes REJECTED
Message-Id: <E1mo7mn-0006Uh-JF@fasolo.debian.org>
Date:   Fri, 19 Nov 2021 17:34:53 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Version check failed:
Your upload included the source package xfsprogs, version 5.14.0-1,
however unstable already has version 5.14.0-rc1-1.
Uploads to unstable must have a higher version than present in unstable.



===

Please feel free to respond to this email if you don't understand why
your files were rejected, or if you upload new files which address our
concerns.

