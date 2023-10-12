Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB5DCDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbjJLFDU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377125AbjJLFDO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:03:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2F8E6
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:03:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4539C6732D; Thu, 12 Oct 2023 07:03:10 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:03:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 7/7] xfs: convert rt extent numbers to xfs_rtxnum_t
Message-ID: <20231012050309.GI1637@lst.de>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <169704720833.1773388.4754367347907860075.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720833.1773388.4754367347907860075.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
