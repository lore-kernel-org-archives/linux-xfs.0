Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A729BC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F9D22249
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgJOHsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:48:43 -0400
Received: from verein.lst.de ([213.95.11.211]:59491 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgJOHsn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Oct 2020 03:48:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 43F4F68B05; Thu, 15 Oct 2020 09:48:42 +0200 (CEST)
Date:   Thu, 15 Oct 2020 09:48:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: annotate grabbing the realtime bitmap/summary
 locks in growfs
Message-ID: <20201015074842.GH14082@lst.de>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia> <160235126770.1384192.7924916439728391885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160235126770.1384192.7924916439728391885.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
