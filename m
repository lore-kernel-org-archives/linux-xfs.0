Return-Path: <SRS0=nhRG=CO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFF0C433E2
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 16:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0292072D
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 16:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgIEQeR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Sep 2020 12:34:17 -0400
Received: from mail.qboosh.pl ([217.73.31.61]:59128 "EHLO mail.qboosh.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgIEQeQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Sep 2020 12:34:16 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Sep 2020 12:34:15 EDT
Received: from stranger.qboosh.pl (159-205-223-43.adsl.inetia.pl [159.205.223.43])
        by mail.qboosh.pl (Postfix) with ESMTPSA id 4A5461A26DA9
        for <linux-xfs@vger.kernel.org>; Sat,  5 Sep 2020 18:24:46 +0200 (CEST)
Received: from stranger.qboosh.pl (localhost [127.0.0.1])
        by stranger.qboosh.pl (8.16.1/8.16.1) with ESMTP id 085GRRbd003120
        for <linux-xfs@vger.kernel.org>; Sat, 5 Sep 2020 18:27:27 +0200
Received: (from qboosh@localhost)
        by stranger.qboosh.pl (8.16.1/8.16.1/Submit) id 085GRQ49003115
        for linux-xfs@vger.kernel.org; Sat, 5 Sep 2020 18:27:26 +0200
Date:   Sat, 5 Sep 2020 18:27:26 +0200
From:   Jakub Bogusz <qboosh@pld-linux.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] Polish translation update for xfsprogs 5.8.0
Message-ID: <20200905162726.GA32628@stranger.qboosh.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I prepared an update of Polish translation of xfsprogs 5.8.0.
Because of size (whole file is ~551kB, diff is ~837kB),
I'm sending just diff header to the list and whole file is available
to download at:
http://qboosh.pl/pl.po/xfsprogs-5.8.0.pl.po
(sha256: 2f0946989b9ba885aa3d3d2b28c5568ce0463a5888b06cfa3f750dc925ceef01)

Whole diff is available at:
http://qboosh.pl/pl.po/xfsprogs-5.8.0-pl.po-update.patch
(sha256: 355a68fcb9cd7b02b762becabdb100b9498ec8a0147efd5976dc9e743190b050)

Please update.


Diff header is:

Polish translation update for xfsprogs 5.8.0.

Signed-off-by: Jakub Bogusz <qboosh@pld-linux.org>

---
 po/pl.po | 17829 +++++++++++++++++++++++++++++++++++-------------------------------
  1 file changed, 9711 insertions(+), 8118 deletions(-)

--- xfsprogs-5.8.0/po/pl.po.orig        2020-08-27 02:45:03.000000000 +0200
+++ xfsprogs-5.8.0/po/pl.po     2020-09-05 18:08:10.009486802 +0200
[...]


Regards,

-- 
Jakub Bogusz    http://qboosh.pl/
