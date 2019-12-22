Return-Path: <SRS0=cf1J=2M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244EDC2D0C8
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 18:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E724D206D3
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 18:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLVS6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Dec 2019 13:58:39 -0500
Received: from mail.qboosh.pl ([217.73.31.61]:56669 "EHLO mail.qboosh.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfLVS6j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Dec 2019 13:58:39 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Dec 2019 13:58:38 EST
Received: from stranger.qboosh.pl (159-205-225-178.adsl.inetia.pl [159.205.225.178])
        by mail.qboosh.pl (Postfix) with ESMTPSA id C6C7B1A26DA9
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 19:52:42 +0100 (CET)
Received: from stranger.qboosh.pl (localhost [127.0.0.1])
        by stranger.qboosh.pl (8.15.2/8.15.2) with ESMTP id xBMIrVhq021982
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 19:53:31 +0100
Received: (from qboosh@localhost)
        by stranger.qboosh.pl (8.15.2/8.15.2/Submit) id xBMIrVGq021979
        for linux-xfs@vger.kernel.org; Sun, 22 Dec 2019 19:53:31 +0100
Date:   Sun, 22 Dec 2019 19:53:31 +0100
From:   Jakub Bogusz <qboosh@pld-linux.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] Polish translation update for xfsprogs 5.4.0
Message-ID: <20191222185331.GA19278@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I prepared an update of Polish translation of xfsprogs 5.4.0.
As previously, because of size (whole file is ~540kB, diff is ~944kB),
I'm sending just commit header to the list and whole file is available
to download at:
http://qboosh.pl/pl.po/xfsprogs-5.4.0.pl.po
(sha256: cb3d01253b723c6ddcf045e7b1ea2e4154ca79404e438042d75eb359f97e539d)

Whole diff is available at:
http://qboosh.pl/pl.po/0001-po-pl.po-update-Polish-translation-for-5.4.0.patch
(sha256: 42c32a1837c74ccc2474b4a2c19b3d5bac9e9e6ceb9f69a02f9eebe763fcd57e)

Commit header:

From 932f1a691eca53131f515285205d018f5931f5b8 Mon Sep 17 00:00:00 2001
From: Jakub Bogusz <qboosh@pld-linux.org>
Date: Sun, 22 Dec 2019 19:44:48 +0100
Subject: [PATCH] po/pl.po: update Polish translation for 5.4.0

Polish translation update for xfsprogs 5.4.0

Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

---
 po/pl.po | 21417 ++++++++++++++++++++++++++++-------------------------
  1 file changed, 11319 insertions(+), 10098 deletions(-)


-- 
Jakub Bogusz    http://qboosh.pl/
