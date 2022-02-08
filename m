Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8ACC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 03:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbiBHDX0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 22:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiBHDXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 22:23:25 -0500
Received: from out20-13.mail.aliyun.com (out20-13.mail.aliyun.com [115.124.20.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4E0C043188
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 19:23:24 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2713581|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.0891303-0.0109245-0.899945;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.MmnQVXr_1644290600;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.MmnQVXr_1644290600)
          by smtp.aliyun-inc.com(10.147.41.187);
          Tue, 08 Feb 2022 11:23:20 +0800
Date:   Tue, 08 Feb 2022 11:23:23 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: Any guide to replace a xfs logdev?
Message-Id: <20220208112322.E7D4.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Any guide to replace a xfs logdev?

case 1: logdev device failed.
case 2: replace the logdev with a new NVDIMM-N device.

but I failed to find out some guide to  replace a xfs logdev.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/02/08


