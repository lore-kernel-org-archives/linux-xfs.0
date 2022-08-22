Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6753C28D13
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiHVQHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbiHVQHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:07:32 -0400
X-Greylist: delayed 426 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Aug 2022 09:07:29 PDT
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9011932040
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 09:07:29 -0700 (PDT)
Received: from stranger.qboosh.pl (37-128-13-199.adsl.inetia.pl [37.128.13.199])
        by mail.qboosh.pl (Postfix) with ESMTPSA id 9B8E71A26DA9
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 18:00:23 +0200 (CEST)
Received: from stranger.qboosh.pl ([127.0.0.1])
        by stranger.qboosh.pl (8.16.1/8.16.1) with ESMTP id 27MG0Mxq010285
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 18:00:23 +0200
Received: (from qboosh@localhost)
        by stranger.qboosh.pl (8.16.1/8.16.1/Submit) id 27MG0Mwp010282
        for linux-xfs@vger.kernel.org; Mon, 22 Aug 2022 18:00:22 +0200
Date:   Mon, 22 Aug 2022 18:00:22 +0200
From:   Jakub Bogusz <qboosh@pld-linux.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] Polish translation update for xfsprogs 5.19.0
Message-ID: <20220822160022.GA10067@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I prepared an update of Polish translation of xfsprogs 5.19.0.
As previously, because of size (whole file is ~574kB, diff is ~750kB),
I'm sending just diff header to the list and whole file is available
to download at:
http://qboosh.pl/pl.po/xfsprogs-5.19.0.pl.po
(sha256: e5f73247e6c029902ef7c341170e5855599c364c50e3f98cc525a54ab17686e0)

Whole diff is available at:
http://qboosh.pl/pl.po/xfsprogs-5.19.0-pl.po-update.patch
(sha256: b9aa4a60c7c0984880ffbac82e836c5a202b01d481cb9a0f0398eeee6ffac637)

Please update.


Diff header is:

Polish translation update for xfsprogs 5.19.0.

Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

---
 pl.po |17011 ++++++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 8894 insertions(+), 8117 deletions(-)

--- xfsprogs-5.19.0/po/pl.po.orig       2022-06-01 20:30:20.000000000 +0200
+++ xfsprogs-5.19.0/po/pl.po    2022-08-21 21:30:05.004759894 +0200
[...]


Regards,

-- 
Jakub Bogusz    http://qboosh.pl/
