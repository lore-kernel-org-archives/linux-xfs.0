Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89D6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 21:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiB1V6W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiB1V6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 16:58:22 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ADB913D53
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 13:57:41 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9EC30116E2;
        Mon, 28 Feb 2022 15:56:42 -0600 (CST)
Message-ID: <a59fc42e-1557-1ab9-b4bd-9cb92ff09b03@sandeen.net>
Date:   Mon, 28 Feb 2022 15:57:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: Fwd: [PATCH] xfs_quota: Support XFS_GETNEXTQUOTA in range calls
Content-Language: en-US
To:     =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>,
        linux-xfs@vger.kernel.org
References: <20211209123934.736295-1-arekm@maven.pl>
 <fbd06eb0-5d01-a01b-fb5a-af1f8a1ba053@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <fbd06eb0-5d01-a01b-fb5a-af1f8a1ba053@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/9/21 6:42 AM, Arkadiusz Miśkiewicz wrote:
> 
> vger still blocks my default domain, so I hope this forward via
> thundebird from another domain will get thru and patch won't get corrupted.

I think this did get mangled. Do you mind sending a copy directly to me,
if you still have it around?

Thanks,
-Eric
