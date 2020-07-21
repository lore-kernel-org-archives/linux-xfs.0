Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB654C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 15:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67FE20709
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 15:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGUPC0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 11:02:26 -0400
Received: from verein.lst.de ([213.95.11.211]:52526 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgGUPC0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Jul 2020 11:02:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 77EAA68AFE; Tue, 21 Jul 2020 17:02:24 +0200 (CEST)
Date:   Tue, 21 Jul 2020 17:02:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH] xfsprogs: remove the libxfs_* API redirections
Message-ID: <20200721150224.GA10063@lst.de>
References: <20200710160259.540991-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710160259.540991-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eric, any comments this time?  Last time you wanted to delay it a bit,
but I'd really like this gone for good before the next resync round..
