Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46395C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 15:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C7A64E3D
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 15:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhBCPu6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:50:58 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40285 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234632AbhBCPut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 10:50:49 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 113FnXoE016131
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 3 Feb 2021 10:49:34 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id B364015C39E2; Wed,  3 Feb 2021 10:49:33 -0500 (EST)
Date:   Wed, 3 Feb 2021 10:49:33 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 00/12] lazytime fix and cleanups
Message-ID: <YBrGDQ0eDOfz/14r@mit.edu>
References: <20210109075903.208222-1-ebiggers@kernel.org>
 <20210111151517.GK18475@quack2.suse.cz>
 <X/y4s12YrXiUwWfN@sol.localdomain>
 <YBowmPPHfZUTBgz1@mit.edu>
 <YBozCMnv1BT8ZyXG@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBozCMnv1BT8ZyXG@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 09:22:16PM -0800, Eric Biggers wrote:
> 
> I already sent out v3 of this series several weeks ago
> (https://lkml.kernel.org/r/20210112190253.64307-1-ebiggers@kernel.org),
> and Jan applied it already.

Great, thanks.  Sorry, I missed it.

       		       	 	- Ted
