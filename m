Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfBFEGA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Feb 2019 23:06:00 -0500
Date: Tue, 5 Feb 2019 23:05:59 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190206040559.GA4119@sasha-vm>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190205220655.GF14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Wed, Feb 06, 2019 at 09:06:55AM +1100, Dave Chinner wrote:
>On Mon, Feb 04, 2019 at 08:54:17AM -0800, Luis Chamberlain wrote:
>> Kernel stable team,
>>
>> here is a v2 respin of my XFS stable patches for v4.19.y. The only
>> change in this series is adding the upstream commit to the commit log,
>> and I've now also Cc'd stable@vger.kernel.org as well. No other issues
>> were spotted or raised with this series.
>>
>> Reviews, questions, or rants are greatly appreciated.
>
>Test results?
>
>The set of changes look fine themselves, but as always, the proof is
>in the testing...

Luis noted on v1 that it passes through his oscheck test suite, and I
noted that I haven't seen any regression with the xfstests scripts I
have.

What sort of data are you looking for beyond "we didn't see a
regression"?

--
Thanks,
Sasha
