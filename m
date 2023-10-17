Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114E6CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 16:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjJQQdI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 12:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjJQQdI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 12:33:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A69E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 09:33:07 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9525F67373; Tue, 17 Oct 2023 18:33:04 +0200 (CEST)
Date:   Tue, 17 Oct 2023 18:33:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/8] xfs: create helpers for rtbitmap block/wordcount
 computations
Message-ID: <20231017163304.GA22722@lst.de>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs> <169755742224.3167663.15974421496522378116.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755742224.3167663.15974421496522378116.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
