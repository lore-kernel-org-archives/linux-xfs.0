Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697D0CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347049AbjJLFCA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347036AbjJLFB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:01:58 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8C290
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:01:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3851D6732D; Thu, 12 Oct 2023 07:01:55 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:01:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 5/7] xfs: convert rt bitmap extent lengths to
 xfs_rtbxlen_t
Message-ID: <20231012050154.GG1637@lst.de>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <169704720803.1773388.2340578935063895607.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720803.1773388.2340578935063895607.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
