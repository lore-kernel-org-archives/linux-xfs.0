Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDCBC7EE25
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 13:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbjFGNbI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240221AbjFGNbI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 09:31:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B291732
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 06:31:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 56C0F6732D; Wed,  7 Jun 2023 15:30:59 +0200 (CEST)
Date:   Wed, 7 Jun 2023 15:30:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Weifeng Su <suweifeng1@huawei.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
        sandeen@sandeen.net, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com
Subject: Re: [PATCH] libxcmd: add return value check for dynamic memory
 function
Message-ID: <20230607133059.GA20840@lst.de>
References: <20230607093018.61752-1-suweifeng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607093018.61752-1-suweifeng1@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
