Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5139C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 01:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjDSB6Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 21:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjDSB6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Apr 2023 21:58:20 -0400
Received: from out28-62.mail.aliyun.com (out28-62.mail.aliyun.com [115.124.28.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C4F61A7
        for <linux-xfs@vger.kernel.org>; Tue, 18 Apr 2023 18:58:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3300404|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.210906-0.00369126-0.785403;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.SJw1EQn_1681869476;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.SJw1EQn_1681869476)
          by smtp.aliyun-inc.com;
          Wed, 19 Apr 2023 09:57:57 +0800
Date:   Wed, 19 Apr 2023 09:57:59 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: could we add superblock to xfs logdev/rtdev?
Message-Id: <20230419095757.220A.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

could we add superblock to xfs logdev/rtdev?

then it will be reported by blkid well,
and then we can find logdev/rtdev auto when xfs mount?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/04/19


