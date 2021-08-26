Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D000C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 14:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269B160EE0
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 14:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhHZOy5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 10:54:57 -0400
Received: from sandeen.net ([63.231.237.45]:48786 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhHZOy5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Aug 2021 10:54:57 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1C75B79F9;
        Thu, 26 Aug 2021 09:53:48 -0500 (CDT)
Subject: Re: xfs.org: Unknown error in PHP's mail() function.
To:     Paul Menzel <pmenzel@molgen.mpg.de>, linux-xfs@vger.kernel.org
References: <b0369a19-b313-1279-0a46-14b501977d1e@molgen.mpg.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <38bacd99-fe8e-ff51-d727-bcb3c9060852@sandeen.net>
Date:   Thu, 26 Aug 2021 09:54:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b0369a19-b313-1279-0a46-14b501977d1e@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/26/21 3:02 AM, Paul Menzel wrote:
> Dear xfs.org folks,
> 
> 
> I am trying to create a Wiki account [1], but after clicking the button *Request account*, only the error message below is shown.
> 
>> Error sending mail:
>>
>> Unknown error in PHP's mail() function. 

xfs.org is unfortunately not under the xfs development community's control,
and is essentially unmaintained at this point.

-Eric
