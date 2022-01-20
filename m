Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84CCC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 01:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbiATBRM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:17:12 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37034 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231224AbiATBRM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 20:17:12 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 20K1Guq4007957
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 20:16:57 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id CE5C315C40F6; Wed, 19 Jan 2022 20:16:56 -0500 (EST)
Date:   Wed, 19 Jan 2022 20:16:56 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 12/17] xfs_scrub: report optional features in version
 string
Message-ID: <Yei4CAWLzMmG33cf@mit.edu>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263816090.863810.16834243121150635355.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164263816090.863810.16834243121150635355.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 19, 2022 at 04:22:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ted T'so reported brittleness in the fstests logic in generic/45[34] to

Not a super big deal, but my last name is "Ts'o".

Thanks,

						- Ted
