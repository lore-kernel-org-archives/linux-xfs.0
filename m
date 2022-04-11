Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3019C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 01:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbiDKBQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 21:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiDKBQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 21:16:00 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB0B63A5C0
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:13:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3780453B9C3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 11:13:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndick-00GF8F-Aq
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 11:13:46 +1000
Date:   Mon, 11 Apr 2022 11:13:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: master and for-next branches updated to v5.18-rc2
Message-ID: <20220411011346.GP1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=625380cc
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10 a=n3xvM8a_0i4A:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just updated the master and for-next branches of the
xfs-linux tree to v5.18-rc2. I would appreciate it if patchsets
for review and pull requests are based on this master branch so I
have a common base to merge patchsets from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
