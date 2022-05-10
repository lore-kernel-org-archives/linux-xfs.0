Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E1AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 09:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiEJJlU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 05:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238983AbiEJJkl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:40:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DFD3123E
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9xqusQYmvsQ6AYdnvsOiDJWjgdLZ1V9Ph5VilnOJaDE=; b=knJFE+ra0FyxHtP30zWzhX7ir2
        clbBuDRrC6dNv6+Bg6SCRn4DtSmmuOIRM5L+xdk4KA2R1JL2VVSyReR4+QZ9vV6Jm0WM/tJtVb6JS
        DHkKZPYNFjlpif9IJ1MW0mT8IKJV9G0YtQnzKylrpeyBuBLlJKbS4g2/1prdXPHzUhs+0X5yFwvbE
        mR+jlm2IwcdFGane7KYU19UnUERQrQrJYHiUoC3JRu0Yc74bfpHiuBsldW71qekl36haI0LJkWweu
        snfich0fjl0+d7ubRWlwK2hRm5jhO99TjkOb6sMo8JaAjl2U0r2x57mKbWK5L2wYH9otD2MtKUORc
        d10MxA/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMIL-000sJy-Ve; Tue, 10 May 2022 09:36:42 +0000
Date:   Tue, 10 May 2022 02:36:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] debian: bump compat level to 11
Message-ID: <YnoyKVvna70anYp6@infradead.org>
References: <165176661877.246788.7113237793899538040.stgit@magnolia>
 <165176663020.246788.2313882264959489186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176663020.246788.2313882264959489186.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Up to eleven is always good!

Reviewed-by: Christoph Hellwig <hch@lst.de>

