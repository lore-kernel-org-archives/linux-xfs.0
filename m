Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4138CEB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 05:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjFPFt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjFPFt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 01:49:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE72270C
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 22:49:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0643667373; Fri, 16 Jun 2023 07:49:54 +0200 (CEST)
Date:   Fri, 16 Jun 2023 07:49:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, Christoph Hellwig <hch@lst.de>,
        kernel test robot <oliver.sang@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/8] xfsprogs: sync with 6.4
Message-ID: <20230616054953.GD28499@lst.de>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The whole series looks good to me.

