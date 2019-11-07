Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730A5C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 21:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 391E92084D
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 21:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfKGV41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 16:56:27 -0500
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:54424 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725882AbfKGV41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 16:56:27 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 50C2F18038B42;
        Thu,  7 Nov 2019 21:56:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: grass20_72512f48a5951
X-Filterd-Recvd-Size: 1204
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Thu,  7 Nov 2019 21:56:25 +0000 (UTC)
Message-ID: <e8187485a6ee7fffef738f90cddfa052ccdb927c.camel@perches.com>
Subject: Re: [PATCH] xfs: Correct comment tyops -> typos
From:   Joe Perches <joe@perches.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 07 Nov 2019 13:56:13 -0800
In-Reply-To: <20191107212541.GF6219@magnolia>
References: <0ceb6a89da4424a4500789610fae4d05ba45ba86.camel@perches.com>
         <20191107212541.GF6219@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-11-07 at 13:25 -0800, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 10:01:15PM -0800, Joe Perches wrote:
> > Just fix the typos checkpatch notices...
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Darrick?  You are the listed maintainer here.
Are you applying this or just reviewing it?


