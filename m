Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfGCCrG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jul 2019 22:47:06 -0400
Date: Tue, 2 Jul 2019 22:47:04 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [STABLE 4.19] fixes for xfs memory and fs corruption
Message-ID: <20190703024704.GT11506@sasha-vm>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
 <20190213205804.GE32253@magnolia>
 <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
 <20190627233216.GD11506@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190627233216.GD11506@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Greg KH <gregkh@linuxfoundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, stable <stable@vger.kernel.org>

On Thu, Jun 27, 2019 at 07:32:17PM -0400, Sasha Levin wrote:
>On Thu, Jun 27, 2019 at 07:12:48PM +0300, Amir Goldstein wrote:
>>Darrick,
>>
>>Can I have your blessing on the choice of these upstream commits
>>as stable candidates?
>>I did not observe any xfstests regressions when testing v4.19.55
>>with these patches applied.
>>
>>Sasha,
>>
>>Can you run these patches though your xfstests setup?
>>They fix nasty bugs.
>
>Will do. Tests running now - I'll update tomorrow.

I gave it a few more days, and it looks good here.

--
Thanks,
Sasha
