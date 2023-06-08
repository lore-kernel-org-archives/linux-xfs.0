Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDD9C7EE2E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 05:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbjFHFkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 01:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbjFHFkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 01:40:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DC4268E
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 22:40:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 49D626732D; Thu,  8 Jun 2023 07:40:10 +0200 (CEST)
Date:   Thu, 8 Jun 2023 07:40:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Weifeng Su <suweifeng1@huawei.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
        sandeen@sandeen.net, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com
Subject: Re: [PATCH v2] libxcmd: add return value check for dynamic memory
 function
Message-ID: <20230608054010.GA11513@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Still looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
