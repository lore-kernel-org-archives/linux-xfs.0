Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83A4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 19:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83CE66137A
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 19:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355173AbhJATIq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Oct 2021 15:08:46 -0400
Received: from sandeen.net ([63.231.237.45]:48960 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354937AbhJATIp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Oct 2021 15:08:45 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BC23F14A18;
        Fri,  1 Oct 2021 14:06:20 -0500 (CDT)
Subject: Re: [PATCH 05/61] libxfs: fix whitespace inconsistencies with kernel
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174722210.350433.13099529255108655931.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bd174989-030a-04cb-74df-e7ec3c899374@sandeen.net>
Date:   Fri, 1 Oct 2021 14:06:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163174722210.350433.13099529255108655931.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/15/21 6:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix a few places where the whitespace isn't an exact match for the
> kernel.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


