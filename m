Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57110 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731704AbfAIPA1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jan 2019 10:00:27 -0500
Subject: Re: [PATCH] xfsdump: don't fail installation if /sbin is symlink of
 /usr/sbin
References: <20181101104732.19322-1-jtulak@redhat.com>
 <1a662234-f71a-7208-76f9-9f2f89aa8255@sandeen.net>
 <c9bea20c-058c-d715-8b2b-9ac55e77c131@sandeen.net>
 <CACj3i702aS2Dw_i_8PAGOD6=AFYCuuHqf3EkUop5nhmKoo317A@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <246936bb-cb92-b6c1-c766-a4547ad7f3f0@sandeen.net>
Date: Wed, 9 Jan 2019 09:00:25 -0600
MIME-Version: 1.0
In-Reply-To: <CACj3i702aS2Dw_i_8PAGOD6=AFYCuuHqf3EkUop5nhmKoo317A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 1/9/19 7:53 AM, Jan Tulak wrote:
> On Wed, Dec 5, 2018 at 5:56 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 12/4/18 10:48 PM, Eric Sandeen wrote:
>>> On 11/1/18 5:47 AM, Jan Tulak wrote:
> 
> snip
> 
>>>
>>> so, um, I guess this seems ok to handle the /sbin == /usr/sbin case.
>>>
>>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Heh, ok, yes your fix is what I should have done 6 years ago :D
>>
>> Thanks,
>> -Eric
> 
> This is not merged yet. Maybe it just got off your list somehow? :-)

Yep, it fell through the cracks, thanks for the reminder.

-Eric
