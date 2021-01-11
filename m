Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F726C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 10:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB912221ED
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 10:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbhAKKxn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:53:43 -0500
Received: from verein.lst.de ([213.95.11.211]:50179 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729420AbhAKKxn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 05:53:43 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 190C567373; Mon, 11 Jan 2021 11:53:01 +0100 (CET)
Date:   Mon, 11 Jan 2021 11:53:00 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 09/12] fs: improve comments for
 writeback_single_inode()
Message-ID: <20210111105300.GD2502@lst.de>
References: <20210109075903.208222-1-ebiggers@kernel.org> <20210109075903.208222-10-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109075903.208222-10-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
