Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6410CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 18:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjJRSFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 14:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjJRSFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 14:05:53 -0400
X-Greylist: delayed 341 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Oct 2023 11:05:47 PDT
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0188B112
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 11:05:46 -0700 (PDT)
Received: from stranger.qboosh.pl (178-36-213-188.dynamic.inetia.pl [178.36.213.188])
        by mail.qboosh.pl (Postfix) with ESMTPSA id 6284A1A26DA9
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 20:00:15 +0200 (CEST)
Received: from stranger.qboosh.pl (localhost [127.0.0.1])
        by stranger.qboosh.pl (8.16.1/8.16.1) with ESMTP id 39II2DdY008672
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 20:02:13 +0200
Received: (from qboosh@localhost)
        by stranger.qboosh.pl (8.16.1/8.16.1/Submit) id 39II2CIU008671
        for linux-xfs@vger.kernel.org; Wed, 18 Oct 2023 20:02:12 +0200
Date:   Wed, 18 Oct 2023 20:02:12 +0200
From:   Jakub Bogusz <qboosh@pld-linux.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] Polish translation update for xfsprogs 6.5.0
Message-ID: <20231018180212.GA8559@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hello,

I prepared an update of Polish translation of xfsprogs 6.5.0.
As previously, because of size (whole file is ~580kB, diff is ~649kB),
I'm sending just diff header to the list and whole file is available
to download at:
http://qboosh.pl/pl.po/xfsprogs-6.5.0.pl.po
(sha256: ff8c6539dff79ca309a6d32b1edfd5923dbc33ce55c0494b37141155155ab453)

Whole diff is available at:
http://qboosh.pl/pl.po/xfsprogs-6.5.0-pl.po-update.patch
(sha256: 1d917df2dbbf88c2cfa89b3e772305a851e1a3ee60649ffc001d667945436040)

Please update.


Diff header is:

Polish translation update for xfsprogs 6.5.0.

Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

---
 pl.po |16075 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 8137 insertions(+), 7938 deletions(-)

--- xfsprogs-6.5.0/po/pl.po.orig        2022-11-14 12:04:05.000000000 +0100
+++ xfsprogs-6.5.0/po/pl.po     2023-10-18 19:28:16.816695390 +0200
[...]


Regards,

-- 
Jakub Bogusz    http://qboosh.pl/
