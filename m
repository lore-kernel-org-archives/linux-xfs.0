Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E0EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 12:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiCXMv6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 08:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiCXMv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 08:51:58 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064EE55BD9
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 05:50:25 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nXMv2-0007At-5V; Thu, 24 Mar 2022 13:50:24 +0100
Message-ID: <973dfde3-8377-5ead-4022-c32a7ed9ffc6@leemhuis.info>
Date:   Thu, 24 Mar 2022 13:50:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [Bug 215687] New: chown behavior on XFS is changed
Content-Language: en-US
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        linux-xfs@vger.kernel.org, bugzilla-daemon@kernel.org
References: <bug-215687-201763@https.bugzilla.kernel.org/>
 <5d1a6abb-f2e7-55bb-a616-04890f3186f2@leemhuis.info>
In-Reply-To: <5d1a6abb-f2e7-55bb-a616-04890f3186f2@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1648126226;9b8b0ca1;
X-HE-SMSGID: 1nXMv2-0007At-5V
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24.03.22 11:22, Thorsten Leemhuis wrote:
> On 15.03.22 09:12, bugzilla-daemon@kernel.org wrote:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=215687
>>
>>            Summary: chown behavior on XFS is changed
> 
> Darrick, what's up with this bug reported more than ten days ago? 

Ahh, Zorro Lang replied in the ticket, seems things are okay now after
your discussed this on IRC, so let me remove this from the regression
tracking; if somebody really complains we ca start to track this again.

#regzbot invalid: seems reporter is okay with the changed behavior after
discussing this with the maintainer
https://bugzilla.kernel.org/show_bug.cgi?id=215687#c4

